# frozen_string_literal: true

require 'spec_helper'

describe Searchable, elasticsearch: true do
  let!(:ada) { FactoryBot.create(:ada, twitter_de: 'alovelace_de', topic_list: %w[ruby algorithm], email: 'info@example.com') }
  before do
    FactoryBot.create(:marie)
    FactoryBot.create(:unpublished_profile, firstname: 'Fred')
  end

  describe 'elasticsearch index' do
    it 'should be created' do
      expect(ada.__elasticsearch__.index_name).to eq 'speakerinnen_liste_application_test'
    end
  end

  describe '#as_indexed_json creates an index that' do
    it 'contains the attribute firstname' do
      expect(ada.as_indexed_json['firstname']).to eq 'Ada'
    end

    it 'contains the attribute lastname' do
      expect(ada.as_indexed_json['lastname']).to eq 'Lovelace'
    end

    it 'contains the attribute fullname' do
      expect(ada.as_indexed_json['fullname']).to eq 'Ada Lovelace'
    end

    it 'contains the attribute twitter_de handle' do
      expect(ada.as_indexed_json['twitter_de']).to eq 'alovelace_de'
    end

    it 'contains the attribute twitter_en handle' do
      expect(ada.as_indexed_json['twitter_en']).to eq 'alovelace'
    end

    it 'contains the attribute topic list' do
      expect(ada.as_indexed_json['topic_list']).to eq %w[ruby algorithm]
    end

    it 'contains the attribute language' do
      expect(ada.as_indexed_json['iso_languages']).to eq ['en','de']
    end

    it 'contains the attribute cities' do
      expect(ada.as_indexed_json['cities']).to eq ['London']
    end

    it 'contains the attribute country' do
      expect(ada.as_indexed_json['country']).to eq 'GB'
    end

    it 'contains the attribute bio_de' do
      expect(ada.as_indexed_json['bio_de']).to eq 'Sie hat den ersten Algorithmus veröffentlicht.'
    end

    it 'contains the attribute bio_en' do
      expect(ada.as_indexed_json['bio_en']).to eq 'She published the first algorithm for a machine.'
    end

    it 'contains the attribute main_topic_de' do
      expect(ada.as_indexed_json['main_topic_de']).to eq 'Mathematik Genie'
    end

    it 'contains the attribute main_topic_en' do
      expect(ada.as_indexed_json['main_topic_en']).to eq 'math wiz'
    end

    # it 'contains the attribute medialinks' do
    #   #ToDo we have to create the medialink here and reload tht(ada because.
    #   #the medialink seems already populated. Why does that happen?
    #   FactoryBot.create(:medialinkt(ada_idt(ada.id)
    # t(ada.reload

    #   expect(ada.as_indexed_json['medialinks'][0]['title']).to eq 'thisTitle'
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
      expect(Profile.__elasticsearch__.search('ada').results.first.fullname).to eq('Ada Lovelace')
    end

    it 'shows results that are a partial match with more than one search input' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('ada curie').results[1].fullname).to eq('Marie Curie')
      expect(Profile.__elasticsearch__.search('ada curie').results[0].fullname).to eq('Ada Lovelace')
    end

    it 'does not return unpublished profile' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('Fred').results.total).to eq(0)
    end

    it 'does not return profile that do not match the given search string' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('Rosie').results.total).to eq(0)
    end

    it 'does return profile that match the firstname' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('Ada').results.first.fullname).to eq('Ada Lovelace')
    end

    it 'does return profile that match the firstname and the lastname' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('Ada Lovelace').results.first.fullname).to eq('Ada Lovelace')
    end

    it 'does return profile that match the twittername' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('alovelace').results.first.fullname).to eq('Ada Lovelace')
    end

    it 'does return profile hat matches the topic' do
      ada.topic_list.add('writer')
      ada.save!
      Profile.__elasticsearch__.refresh_index!

      expect(Profile.__elasticsearch__.search('writer').results.first.fullname).to eq('Ada Lovelace')
    end

    it 'does return nothing if search is empty' do
      Profile.__elasticsearch__.refresh_index!
      expect(Profile.__elasticsearch__.search('').results.total).to eq(0)
    end
  end
end
