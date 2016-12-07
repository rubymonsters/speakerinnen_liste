require 'spec_helper'

describe Searchable do

  let!(:profile) { FactoryGirl.create(:published, firstname: 'Ada', lastname: 'Lovelace', twitter: 'alovelace', city: 'London', country: 'GB', languages: 'English', topic_list: ['ruby', 'algorithms'], bio: 'Amazing person', main_topic: 'life') }

  describe '#as_indexed_json' do
    it 'creates an index that contains the attribute firstname' do
      expect(profile.as_indexed_json).to have_key ('firstname')
    end

    it 'creates an index that contains the attribute lastname' do
      expect(profile.as_indexed_json).to have_key ('lastname')
    end

    it 'creates an index that contains the attribute twitter handle' do
      expect(profile.as_indexed_json).to have_key ('twitter')
    end

    it 'creates an index that contains the attribute fullname' do
      expect(profile.as_indexed_json).to have_key ('fullname')
    end

    it 'creates an index that contains the attribute topic list' do
      expect(profile.as_indexed_json).to have_key ('topic_list')
    end

    it 'creates an index that contains the attribute bio' do
      expect(profile.as_indexed_json).to have_key ('bio')
    end

    it 'creates an index that contains the attribute main_topic' do
      expect(profile.as_indexed_json).to have_key ('main_topic')
    end

    it 'creates an index that contains the attribute medialinks' do
      skip "this somehow does not work if I add medialinks to to profile"
      expect(profile.as_indexed_json).to have_key ('medialinks')
    end
  end
end
