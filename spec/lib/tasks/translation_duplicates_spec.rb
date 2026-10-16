require 'rails_helper'
require 'rake'

RSpec.describe 'profiles:translation_duplicates' do
  INDEX = 'index_profile_translations_on_profile_id_and_locale'.freeze

  before(:all) do
    Rails.application.load_tasks if Rake::Task.tasks.empty?
  end

  def run(task)
    Rake::Task[task].reenable
    Rake::Task[task].invoke
  end

  # The unique index is what stops duplicates recurring, so it has to go away
  # before we can recreate the historical situation. The transactional fixture
  # rolls the DDL back with everything else.
  def without_unique_index
    ActiveRecord::Base.connection.execute("DROP INDEX IF EXISTS #{INDEX}")
    yield
  end

  let(:profile) { FactoryBot.create(:published_profile) }

  describe 'the unique index' do
    it 'prevents a second translation row for the same locale' do
      expect(ActiveRecord::Base.connection.index_name_exists?(:profile_translations, INDEX)).to be true
      expect {
        Profile::Translation.create!(profile_id: profile.id, locale: 'en', city: 'Berlin')
        Profile::Translation.create!(profile_id: profile.id, locale: 'en', city: 'Hamburg')
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end

  describe 'repair' do
    it 'collapses duplicates, keeping the newest row and filling its blanks' do
      without_unique_index do
        Profile::Translation.where(profile_id: profile.id, locale: 'en').delete_all
        older = Profile::Translation.create!(profile_id: profile.id, locale: 'en',
                                             city: 'Oldtown', bio: 'kept from the older row')
        newer = Profile::Translation.create!(profile_id: profile.id, locale: 'en',
                                             city: 'Newtown', bio: nil)
        older.update_columns(updated_at: 2.days.ago)
        newer.update_columns(updated_at: 1.day.ago)

        expect { ENV['APPLY'] = '1'; run('profiles:translation_duplicates:repair') }
          .to change { Profile::Translation.where(profile_id: profile.id, locale: 'en').count }.from(2).to(1)
        ENV.delete('APPLY')

        survivor = Profile::Translation.find_by(profile_id: profile.id, locale: 'en')
        expect(survivor.id).to eq(newer.id)                 # newest wins
        expect(survivor.city).to eq('Newtown')              # its own value is never overwritten
        expect(survivor.bio).to eq('kept from the older row') # blank column filled from the dropped row
      end
    end

    it 'changes nothing without APPLY' do
      without_unique_index do
        Profile::Translation.where(profile_id: profile.id, locale: 'en').delete_all
        2.times { |i| Profile::Translation.create!(profile_id: profile.id, locale: 'en', city: "C#{i}") }
        expect { run('profiles:translation_duplicates:repair') }
          .not_to change { Profile::Translation.where(profile_id: profile.id, locale: 'en').count }
      end
    end
  end
end
