# frozen_string_literal: true

require 'spec_helper'

describe 'profile search' do
  let!(:locale_language_de) { create(:locale_language_de) }
  let!(:locale_language_en) { create(:locale_language_en) }
  let!(:tag_en) { create(:tag_physics, locale_languages: [locale_language_en]) }

  let!(:ada) do
    FactoryBot.create(:published, firstname: 'Ada', lastname: 'Lovelace',
                                      twitter: 'alovelace', city: 'London',
                                      country: 'GB',
                                      iso_languages: ['en'],
                                      topic_list: [ tag_en] ,
                                      bio_de: 'Ada:Das ist meine deutsche Bio.',
                                      bio_en: 'Ada:This is my english bio.',
                                      main_topic_de: 'Das Leben', main_topic_en: 'Life',
                                      email: 'info@example.com')
  end

  let!(:marie) do
    FactoryBot.create(:published, firstname: 'Maria', lastname: 'Curie',
                                      twitter: '', city: 'Paris',
                                      country: 'FR',
                                      iso_languages: %w[en fr],
                                      topic_list: [tag_en],
                                      bio_de: 'Maria: Das ist meine deutsche Bio.',
                                      bio_en: 'Maria: This is my english bio.',
                                      main_topic_de: 'x-ray', main_topic_en: 'Röntgen',
                                      email: 'maria@example.com')
  end
  let!(:profile2) { create(:published, firstname: 'Christiane', lastname: 'König', city: 'Heidelberg') }
  let!(:profile3) { create(:published, firstname: 'Maren ', lastname: 'Meier') }

  let!(:profile_not_matched) { create(:published, firstname: 'Angela', city: 'New York', twitter: '@adavis') }
  let!(:category) { create(:cat_science) }

  describe 'tag filter', js: true do
    before do
      tag = ActsAsTaggableOn::Tag.first
      tag.categories << category
    end

    skip'is skiped because I need to figure out how the new tagfilter can be tested, finds profiles with the selected tag' do
      visit root_path
      save_and_open_page  
      click_button "physicist"
      click_button "Filter"

      expect(page).to have_content('Maria')
    end

    skip 'finds profiles with the selected tags' do
      visit root_path
      click_button "physicist"
      click_button "computer"
      click_button "Filter"

      expect(page).to have_content('Maria')
      expect(page).to have_content('Ada')
      expect(page).to_not have_content('Angela')
    end

  end

  # describe 'public search', elasticsearch: true do
    # it 'displays profiles that are a partial match' do
    # visit root_path
    # fill_in 'search', with: 'Ada Lovelace'
    # click_button(I18n.t(:search, scope: 'pages.home.search'))
    # expect(Profile.__elasticsearch__.search('Ada').results.first.fullname).to eq('Ada Lovelace')
    # expect(page).to have_content('Ada')
    # end

    #     it 'displays profiles that are a partial match with more than one search input' do
    #       visit root_path
    #       fill_in 'search', with: 'Ada Curie'
    #       click_button I18n.t(:search, scope: 'pages.home.search')
    #       #save_and_open_page
    #       expect(page).to have_content('Ada')
    #       expect(page).to have_content('Curie')
    #     end

    #     it 'displays profiles that are a partial match wit UTF-8 characters' do
    #       visit root_path
    #       fill_in 'search', with: 'Koenig'
    #       click_button I18n.t(:search, scope: 'pages.home.search')
    #       expect(page).to have_content('Christiane')
    #     end

    #     it 'displays profiles that have an empty space' do
    #       visit root_path
    #       fill_in 'search_quick', with: 'Maren Meier'
    #       click_button I18n.t(:search, scope: 'pages.home.search')
    #       expect(page).to have_content('Meier')
    #     end
  # end

  # describe 'search in admin area' do
  #   before do
  #     sign_in admin
  #   end
  #   let(:admin) { FactoryBot.create(:admin) }

  #   it 'finds the correct profile' do
  #     visit admin_profiles_path
  #     fill_in 'admin_search', with: 'Ada Lovelace'
  #     click_button I18n.t(:search, scope: 'pages.home.search')
  #     expect(page).to have_content('Ada')
  #   end
  # end

  #   describe 'detailed search' do

  #     before do
  #       visit profiles_path
  #     end

  #     it 'displays profiles partial match for city' do
  #       within '#detailed-search' do
  #         fill_in I18n.t(:city, scope: 'profiles.index'), with: 'Lon'
  #         click_button I18n.t(:search, scope: 'pages.home.search')
  #       end
  #       expect(page).to have_content('Ada')
  #     end

  #     it 'displays profiles that match of the selected country' do
  #       within '#detailed-search' do
  #         select 'United Kingdom', :from => 'Country', :match => :first
  #         click_button I18n.t(:search, scope: 'pages.home.search')
  #       end
  #       expect(page).to have_content('Ada')
  #     end

  #     it 'displays profiles that match any of the selected languages' do
  #       within '#detailed-search' do
  #         select 'Spanish', :from => 'Language'
  #         #select I18n.t(:languages, scope: 'profiles.index'), match: 'Spanish'
  #         click_button I18n.t(:search, scope: 'pages.home.search')
  #       end
  #       expect(page).to have_content('Ada')
  #     end

  #     it 'displays profiles partial match for name' do
  #       within '#detailed-search' do
  #         fill_in I18n.t(:name, scope: 'profiles.index'), with: 'Love'
  #         click_button I18n.t(:search, scope: 'pages.home.search')
  #       end
  #       expect(page).to have_content('Ada')
  #     end

  #     it 'displays profiles partial match for twitter' do
  #       within '#detailed-search' do
  #         fill_in 'Twitter', with: 'Adal'
  #         click_button I18n.t(:search, scope: 'pages.home.search')
  #       end
  #       expect(page).to have_content('Ada')
  #     end

  #     it 'displays profiles partial match for topic' do
  #       skip "TODO: Does not work because it uses javascript now :("
  #       profile.topic_list.add('Algorithm')
  #       profile.save!

  #       visit profiles_path
  #       within '#detailed-search' do
  #         fill_in "profile_topic_list", with: 'Algo'
  #         click_button I18n.t(:search, scope: 'pages.home.search')
  #       end
  #       expect(page).to have_content('Ada')
  #     end
  #   end
end
