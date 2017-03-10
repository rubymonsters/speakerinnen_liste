require 'spec_helper'

describe Searchable, elasticsearch: true do

  let!(:profile) { FactoryGirl.create(:published, firstname: 'Ada', lastname: 'Lovelace',
                                      twitter: 'alovelace', city: 'London',
                                      country: 'GB', languages: 'English',
                                      topic_list: ['ruby', 'algorithms'],
                                      bio: "Das ist meine Deutsche Bio. Bla...", main_topic: 'life', email: 'info@example.com') }
                                      # TO DO: Check bio_by_language, e.g.: bio_by_language: {:en=>"This is my English bio.", :de=>"Das ist meine Deutsche Bio. Bla..."},
  describe 'elasticsearch index' do
    it 'should be created' do
      Profile.__elasticsearch__.refresh_index!
      records = Profile.search('Ada').records
      expect(records.length).to eq(1)
      expect(records.first.lastname).to eq('Lovelace')
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

    it 'contains the attribute language' do
      expect(profile.as_indexed_json['languages']).to eq 'English'
    end

    #test must be adapted for bio_by_language method
    it 'contains the attribute bio_by_language' do
      expect(profile.as_indexed_json['bio']).to eq 'Das ist meine Deutsche Bio. Bla...'
    end

    it 'contains the attribute main_topic' do
      expect(profile.as_indexed_json['main_topic']).to eq 'life'
    end

    # it 'contains the attribute medialinks' do
    #   #ToDo we have to create the medialink here and reload the profile because.
    #   #the medialink seems already populated. Why does that happen?
    #   FactoryGirl.create(:medialink, profile_id: profile.id)
    #   profile.reload

    #   expect(profile.as_indexed_json['medialinks'][0]['title']).to eq 'thisTitle'
    # end
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
