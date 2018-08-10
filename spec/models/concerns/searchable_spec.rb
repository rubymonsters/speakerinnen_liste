# frozen_string_literal: true

require 'spec_helper'

describe Searchable, elasticsearch: true do
  let!(:profile) do
    FactoryBot.create(:published, firstname: 'Ada', lastname: 'Lovelace',
                                      twitter_de: 'alovelace_de', twitter_en: 'alovelace',
                                      city_de: 'London', city_en: 'London', country: 'GB',
                                      iso_languages: ['en'],
                                      topic_list: %w[ruby algorithms],
                                      bio_de: 'Das ist meine deutsche Bio.',
                                      bio_en: 'This is my english bio.',
                                      main_topic_de: 'Das Leben', main_topic_en: 'Life',
                                      email: 'info@example.com')
  end

  let!(:profile2) do
    FactoryBot.create(:published, firstname: 'Marie', lastname: 'Curie',
                                      twitter: 'mcurie', city: 'Paris',
                                      country: 'FR', iso_languages: %w[pl fr])
  end

  let!(:profile_not_published) { FactoryBot.create(:unpublished, firstname: 'Fred') }

  describe 'elasticsearch index' do
    it 'should be created' do
      expect(Profile.__elasticsearch__.index_name).to eq 'speakerinnen_liste_application_test'
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

    it 'contains the attribute twitter_de handle' do
      expect(profile.as_indexed_json['twitter_de']).to eq 'alovelace_de'
    end

    it 'contains the attribute twitter_en handle' do
      expect(profile.as_indexed_json['twitter_en']).to eq 'alovelace'
    end

    it 'contains the attribute topic list' do
      expect(profile.as_indexed_json['topic_list']).to eq %w[ruby algorithms]
    end

    it 'contains the attribute language' do
      expect(profile.as_indexed_json['iso_languages']).to eq ['en']
    end

    it 'contains the attribute cities' do
      expect(profile.as_indexed_json['cities']).to eq ['London']
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
    #   FactoryBot.create(:medialink, profile_id: profile.id)
    #   profile.reload

    #   expect(profile.as_indexed_json['medialinks'][0]['title']).to eq 'thisTitle'
    # end
  end

  describe '#search' do
    it 'should get search results' do
      Profile.__elasticsearch__.refresh_index!
      response = Profile.__elasticsearch__.search('Lovelace')
      expect(response.results.total).to eq(1)
    end

    it 'should not index certain fields' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('info@example.com')).to be_empty
    end

    it 'shows results that are a partial match' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('Ada').results.first.fullname).to eq('Ada Lovelace')
    end

    it 'shows results that are a partial match with more than one search input' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('Ada Curie').results[0].fullname).to eq('Marie Curie')
      expect(Profile.__elasticsearch__.search('Ada Curie').results[1].fullname).to eq('Ada Lovelace')
    end

    it 'does not return unpublished profiles' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('Fred').results.total).to eq(0)
    end

    it 'does not return profiles that do not match the given search string' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('Rosie').results.total).to eq(0)
    end

    it 'does return profiles that match the firstname' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('Ada').results.first.fullname).to eq('Ada Lovelace')
    end

    it 'does return profiles that match the firstname and the lastname' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('Ada Lovelace').results.first.fullname).to eq('Ada Lovelace')
    end

    it 'does return profiles that match the twittername' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('alovelace').results.first.fullname).to eq('Ada Lovelace')
    end

    it 'does return profiles that matches the topic' do
      profile.topic_list.add('algorithm')
      profile.save!
      Profile.__elasticsearch__.refresh_index!

      expect(Profile.__elasticsearch__.search('algorithm').results.first.fullname).to eq('Ada Lovelace')
    end

    it 'does return nothing if search is empty' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('').results.total).to eq(0)
    end
  end
end
