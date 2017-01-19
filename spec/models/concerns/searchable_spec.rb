require 'spec_helper'

describe Searchable, elasticsearch: true do

  let!(:profile) { FactoryGirl.create(:published, firstname: 'Ada', lastname: 'Lovelace',
                                      twitter: 'alovelace', city: 'London',
                                      country: 'GB', languages: 'English',
                                      topic_list: ['ruby', 'algorithms'],
                                      bio: 'Amazing person', main_topic: 'life', email: 'info@example.com') }
  let!(:profile_medialink) { FactoryGirl.create(:medialink, profile_id: profile.id) }

  describe 'elasticsearch index creation' do
    it 'should be indexed' do
      Profile.__elasticsearch__.refresh_index!
      expect(profile.__elasticsearch__.search('Ada').records.length).to eq(1)
    end
  end

  describe '#as_indexed_json creates an index that' do
    it 'contains the attribute firstname' do
      expect(profile.as_indexed_json['firstname']).to eq 'Ada'
    end

    it 'contains the attribute lastname' do
      expect(profile.as_indexed_json['lastname']).to eq 'Lovelace'
    end

    it 'contains the attribute twitter handle' do
      expect(profile.as_indexed_json['twitter']).to eq 'alovelace'
    end

    it 'contains the attribute fullname' do
      expect(profile.as_indexed_json['fullname']).to eq 'Ada Lovelace'
    end

    it 'contains the attribute topic list' do
      expect(profile.as_indexed_json['topic_list']).to eq ['ruby', 'algorithms']
    end

    it 'contains the attribute bio' do
      expect(profile.as_indexed_json['bio']).to eq 'Amazing person'
    end

    it 'contains the attribute main_topic' do
      expect(profile.as_indexed_json['main_topic']).to eq 'life'
    end

    it 'contains the attribute medialinks' do
      expect(profile.as_indexed_json['medialinks'][0]['title']).to eq 'thisTitle'
    end
  end

  describe '#search' do
    it 'should be indexed' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.search('Lovelace').records.is_published.length).to eq(1)
    end

    it 'should not index certain fields' do
      expect(Profile.search('info@example.com')).to be_empty
    end
  end
end
