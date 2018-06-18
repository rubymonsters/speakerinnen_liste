# frozen_string_literal: true

namespace :tags do
  desc 'merges upper case tags into lower case ones'
  task merge: :environment do
    tags = Hash.new { [] }

    ActsAsTaggableOn::Tag.all.each do |tag|
      low_name = tag.name.downcase
      tags[low_name] += [tag]
    end

    puts "Number of tags: #{ActsAsTaggableOn::Tag.count}"
    puts "full Hash-Size: #{tags.size}"

    double_tags = tags.delete_if { |_key, value| value.size < 2 }

    puts "double_tags size: #{double_tags.size}"
    tags_to_edit = {}
    double_tags.each do |_key, tag_pair|
      bad, good = tag_pair.sort_by(&:name)
      tags_to_edit[good] = bad

      tag_pair.sort_by(&:name).each do |tag|
        puts "#{tag.id.to_s.rjust(4)} - #{tag.name}"
      end
      puts '--------------'
    end

    tags_to_edit.each do |good, bad|
      puts "#{good.id} #{good.name} (#{good.taggings.count})"
      puts "#{bad.id} #{bad.name} (#{bad.taggings.count})"
      puts '--------------'
    end

    tags_to_edit.each do |good, bad|
      bad.taggings.each do |t|
        t.update_columns(tag_id: good.id)
      end
      bad.taggings.reload
      bad.destroy!
      ActsAsTaggableOn::Tag.reset_counters(good.id, :taggings)
    end
  end
end
