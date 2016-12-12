require 'spec_helper'

describe Searchable do

  let!(:profile) { FactoryGirl.create(:published, firstname: 'Ada', lastname: 'Lovelace',
                                      twitter: 'alovelace', city: 'London',
                                      country: 'GB', languages: 'English',
                                      topic_list: ['ruby', 'algorithms'],
                                      bio: 'Amazing person', main_topic: 'life') }
  let!(:profile_medialink) { FactoryGirl.create(:medialink, profile_id: profile.id) }

  describe '#as_indexed_json creates an index that' do
    it 'contains the attribute firstname' do
      expect(profile.as_indexed_json).to have_key ('firstname')
      expect(profile.as_indexed_json).to have_value ('Ada')
    end

    it 'contains the attribute lastname' do
      expect(profile.as_indexed_json).to have_key ('lastname')
    end

    it 'contains the attribute twitter handle' do
      expect(profile.as_indexed_json).to have_key ('twitter')
    end

    it 'contains the attribute fullname' do
      expect(profile.as_indexed_json).to have_key ('fullname')
    end

    it 'contains the attribute topic list' do
      expect(profile.as_indexed_json).to have_key ('topic_list')
    end

    it 'contains the attribute bio' do
      expect(profile.as_indexed_json).to have_key ('bio')
    end

    it 'contains the attribute main_topic' do
      expect(profile.as_indexed_json).to have_key ('main_topic')
    end

    it 'contains the attribute medialinks' do
      expect(profile.as_indexed_json).to have_key ('medialinks')
    end
  end
end
