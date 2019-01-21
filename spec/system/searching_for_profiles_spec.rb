# frozen_string_literal: true

require 'spec_helper'

describe 'profile search' do
  let!(:locale_language_en) { create(:locale_language_en) }
  let!(:physics) { create(:tag_physics, locale_languages: [locale_language_en]) }
  let!(:algorithm) { create(:tag_algorithm, locale_languages: [locale_language_en]) }
  let!(:ada) { create(:ada, topic_list: [algorithm]) }
  let!(:marie) { create(:marie, topic_list: [physics]) }
  let!(:profile2) { create(:published, firstname: 'Christiane', lastname: 'König', main_topic_en: 'Blogs') }
  let!(:profile3) { create(:published, firstname: 'Maren ', lastname: 'Meier', main_topic_en: 'Big Data') }

  let!(:profile_not_matched) { create(:published, firstname: 'Angela', main_topic_en: 'rassism' ) }

  describe 'public search', elasticsearch: true do
    it 'displays profiles that are a partial match' do
      visit root_path
      fill_in 'search', with: 'ada lovelace'
      click_button(I18n.t(:search, scope: 'pages.home.search'))
      # expect(profile.__elasticsearch__.search('ada').results.first.fullname).to eq('ada lovelace')
      expect(page).to have_content('Ada')
    end

    it 'displays profiles that are a partial match with more than one search input' do
      visit root_path
      fill_in 'search', with: 'Marie' 
      click_button(I18n.t(:search, scope: 'pages.home.search'))
      # expect(page).to have_content('Ada')
      expect(page).to have_content('Curie')
    end

    it 'displays profiles that are a partial match with utf-8 characters' do
      visit root_path
      fill_in 'search', with: 'koenig'
      click_button I18n.t(:search, scope: 'pages.home.search')
      expect(page).to have_content('Christiane')
    end

    it 'displays profiles that have an empty space' do
      visit root_path
      fill_in 'search', with: 'maren meier'
      click_button I18n.t(:search, scope: 'pages.home.search')
      expect(page).to have_content('Meier')
    end
  end

  describe 'search in admin area' do
    before do
      sign_in admin
    end
    let(:admin) { FactoryBot.create(:admin) }

    it 'finds the correct profile' do
      visit admin_profiles_path
      fill_in 'search', with: 'ada lovelace'
      click_button I18n.t(:search, scope: 'pages.home.search')
      expect(page).to have_content('Lovelace')
    end
  end
end
