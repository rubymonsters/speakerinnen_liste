require 'spec_helper'

describe Searchable, elasticsearch: true do

  let!(:profile) { FactoryGirl.create(:published, firstname: 'Ada', lastname: 'Lovelace',
                                      twitter: 'alovelace', city: 'London',
                                      country: 'GB', languages: 'English',
                                      topic_list: ['ruby', 'algorithms'],
                                      bio_de: 'Das ist meine deutsche Bio.', bio_en: 'This is my english bio.',
                                      main_topic_de: 'Das Leben', main_topic_en: 'Life', email: 'info@example.com') }
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

    it 'contains the attribute fullname' do
      expect(profile.as_indexed_json['fullname']).to eq 'Ada Lovelace'
    end
    it 'contains the attribute twitter handle' do
      expect(profile.as_indexed_json['twitter']).to eq 'alovelace'
    end

    it 'contains the attribute topic list' do
      expect(profile.as_indexed_json['topic_list']).to eq ['ruby', 'algorithms']
    end

    it 'contains the attribute language' do
      expect(profile.as_indexed_json['languages']).to eq 'English'
    end

    it 'contains the attribute city' do
      expect(profile.as_indexed_json['city']).to eq 'London'
    end

    it 'contains the attribute country' do
      expect(profile.as_indexed_json['country']).to eq 'GB'
    end

    it 'contains the attribute bio_de' do
      expect(profile.as_indexed_json['bio_de']).to eq 'Das ist meine deutsche Bio.'
    end

    it 'contains the attribute bio_en' do
      expect(profile.as_indexed_json['bio_en']).to eq 'This is my english bio.'
    end

    it 'contains the attribute main_topic_de' do
      expect(profile.as_indexed_json['main_topic_de']).to eq 'Das Leben'
    end

    it 'contains the attribute main_topic_en' do
      expect(profile.as_indexed_json['main_topic_en']).to eq 'Life'
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
