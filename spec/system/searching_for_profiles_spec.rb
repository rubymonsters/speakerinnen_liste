# frozen_string_literal: true

require 'spec_helper'

describe 'profile search' do
  let!(:locale_language_en) { create(:locale_language_en) }
  let!(:physics) { create(:tag_physics, locale_languages: [locale_language_en]) }
  let!(:algorithm) { create(:tag_algorithm, locale_languages: [locale_language_en]) }
  let!(:ada) { create(:ada, topic_list: [algorithm]) }
  let!(:marie) { create(:marie, topic_list: [physics]) }
  let!(:profile2) { create(:published_profile, firstname: 'Christiane', lastname: 'König', main_topic_en: 'Blogs') }
  let!(:profile3) { create(:published_profile, firstname: 'Maren ', lastname: 'Meier', main_topic_en: 'Big Data') }

  let!(:profile_not_matched) { create(:published_profile, firstname: 'Angela', main_topic_en: 'rassism' ) }

  describe 'public search', elasticsearch: true do
    before { visit root_path }

    it 'displays profiles that are a partial match' do
      Profile.__elasticsearch__.refresh_index!

      fill_in 'search', with: 'ada lovelace'
      click_button(I18n.t(:search, scope: 'pages.home.search'))
      expect(page).to have_content('Ada')
    end

    it 'displays profiles that are a partial match with more than one search input' do
      Profile.__elasticsearch__.refresh_index!

      fill_in 'search', with: 'Marie'
      click_button(I18n.t(:search, scope: 'pages.home.search'))
      expect(page).to have_content('Curie')
    end

    it 'displays profiles that are a partial match with utf-8 characters' do
      Profile.__elasticsearch__.refresh_index!

      fill_in 'search', with: 'koenig'
      click_button I18n.t(:search, scope: 'pages.home.search')
      expect(page).to have_content('Christiane')
    end

    it 'displays profiles that have an empty space' do
      Profile.__elasticsearch__.refresh_index!

      fill_in 'search', with: 'maren meier'
      click_button I18n.t(:search, scope: 'pages.home.search')
      expect(page).to have_content('Meier')
    end

    it 'shows button search' do
      expect(page).to have_selector('#search')
    end

    it 'shows autofill' do
      expect(page).to have_selector('.typeahead')
    end
  end

  context 'on profile_search page' do
    before { visit profiles_path }

    it 'shows button search' do
      expect(page).to have_selector('#search')
    end

    it 'shows autofill' do
      expect(page).to have_selector('.typeahead')
    end
  end

  describe 'search in admin area', elasticsearch: true do
    before do
      sign_in admin
    end
    let(:admin) { FactoryBot.create(:admin) }

    it 'finds the correct profile' do
      Profile.__elasticsearch__.refresh_index!

      visit admin_profiles_path
      fill_in 'search', with: 'ada lovelace'
      click_button I18n.t(:search, scope: 'pages.home.search')
      expect(page).to have_content('Lovelace')
    end
  end
end
