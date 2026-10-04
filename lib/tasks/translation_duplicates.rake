# Profiles can carry more than one profile_translations row for the same locale
# (historically from double-submitted signup forms). Mobility only ever reads
# ONE of them -- `in_locale` is a plain `find` over the association with no
# ORDER BY -- so the surplus row is invisible in the app and in the Rails
# console, while raw SQL still sees it. That makes the extra row leak into
# anything built with SQL: the city/language facets (ProfileGrouper) and the
# full-text search vector.
#
# Because the lookup is unordered, which row the app reads is not stable across
# an UPDATE or a VACUUM. Collapsing each locale to a single row is therefore the
# fix; it is not safe to simply "keep the one the app currently shows".
namespace :profiles do
  namespace :translation_duplicates do
    COLUMNS = -> { Profile::Translation.column_names - %w[id profile_id locale created_at updated_at] }

    # Newest first: the row a human edited most recently wins, and older rows
    # only fill in columns the winner leaves blank.
    def duplicate_groups
      keys = Profile::Translation.group(:profile_id, :locale).having('COUNT(*) > 1').count.keys
      keys.map do |profile_id, locale|
        rows = Profile::Translation.where(profile_id: profile_id, locale: locale)
                                   .order(updated_at: :desc, id: :desc).to_a
        [profile_id, locale, rows]
      end
    end

    def merge_plan(rows)
      keep, *drop = rows
      fills = {}
      COLUMNS.call.each do |col|
        next if keep[col].present?
        donor = drop.find { |r| r[col].present? }
        fills[col] = donor[col] if donor
      end
      [keep, drop, fills]
    end

    desc 'Report profiles carrying more than one translation row per locale'
    task report: :environment do
      groups = duplicate_groups
      if groups.empty?
        puts 'No duplicate translation rows.'
        next
      end
      surplus = groups.sum { |(_, _, rows)| rows.size - 1 }
      puts "#{groups.size} (profile, locale) groups affected, #{surplus} surplus rows\n\n"
      groups.each do |profile_id, locale, rows|
        keep, drop, fills = merge_plan(rows)
        puts "profile #{profile_id} / #{locale}"
        rows.each do |r|
          mark = r.id == keep.id ? 'KEEP' : 'DROP'
          vals = COLUMNS.call.filter_map { |c| "#{c}=#{r[c].to_s.truncate(40).inspect}" if r[c].present? }.join(' ')
          puts format('  %-4s id=%-7d updated=%s  %s', mark, r.id, r.updated_at&.iso8601, vals)
        end
        puts "  fills from dropped rows: #{fills.inspect}" if fills.any?
        puts
      end
      puts 'Nothing was changed. Run profiles:translation_duplicates:repair to apply.'
      puts 'NOTE: this report contains profile content - do not paste it into tickets.'
    end

    desc 'Collapse duplicate translation rows into one per locale (set APPLY=1 to write)'
    task repair: :environment do
      apply  = ENV['APPLY'] == '1'
      groups = duplicate_groups
      if groups.empty?
        puts 'No duplicate translation rows.'
        next
      end

      archive = Rails.root.join('tmp', "translation_duplicates_#{Time.now.utc.strftime('%Y%m%d%H%M%S')}.json")
      deleted, updated = [], 0

      ActiveRecord::Base.transaction do
        groups.each do |_profile_id, _locale, rows|
          keep, drop, fills = merge_plan(rows)
          deleted.concat(drop.map(&:attributes))
          if apply
            keep.update_columns(fills) if fills.any?   # update_columns: no callbacks, no search-vector churn
            Profile::Translation.where(id: drop.map(&:id)).delete_all
          end
          updated += 1
        end
        raise ActiveRecord::Rollback unless apply
      end

      if apply
        File.write(archive, JSON.pretty_generate(deleted))
        puts "Collapsed #{updated} groups, deleted #{deleted.size} rows."
        puts "Deleted rows archived to #{archive}"
        puts 'Now run db:migrate to add the unique index that prevents this recurring.'
      else
        puts "DRY RUN: would collapse #{updated} groups and delete #{deleted.size} rows."
        puts 'Re-run with APPLY=1 to write. Deleted rows are archived to tmp/ when applied.'
      end
    end
  end
end
