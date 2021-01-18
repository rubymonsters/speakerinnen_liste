# frozen_string_literal: true

require 'spec_helper'

def filter_by_themes_xpath(class_name)
  "//span[@class='#{class_name}'][*[contains(text(),'Filter by themes')]]"
end

form_selector = 'form[action="/en/profiles"][method="get"]'

describe 'profile search' do
  let!(:locale_language_en) { create(:locale_language_en) }
  let!(:physics) { create(:tag_physics, locale_languages: [locale_language_en]) }
  let!(:algorithm) { create(:tag_algorithm, locale_languages: [locale_language_en]) }
  let!(:ada) { create(:ada, topic_list: [algorithm]) }
  let!(:marie) { create(:marie, topic_list: [physics]) }
  let!(:phantom_of_the_opera) { create(:phantom_of_the_opera, topic_list: []) }
  let!(:profile2) { create(:published_profile, firstname: 'Christiane', lastname: 'König', main_topic_en: 'Blogs') }
  let!(:profile3) { create(:published_profile, firstname: 'Maren ', lastname: 'Meier', main_topic_en: 'Big Data') }
  let!(:profile_not_matched) { create(:published_profile, firstname: 'Angela', main_topic_en: 'rassism' ) }

  describe 'public search' do
    context 'home page search form' do
      before { visit root_path }

      it 'shows autofill search input' do
        expect(page).to have_selector(".container #{form_selector} input#home_search.typeahead[type='search']")
      end

      it 'shows button search' do
        expect(page).to have_selector(".container #{form_selector} input[type='submit']")
      end
    end

    context 'header form' do
      before { visit root_path }

      it 'shows autofill search input' do
        expect(page).to have_selector(".navbar #{form_selector} input#header_search.typeahead[type='text']")
      end

      it 'shows search button' do
        expect(page).to have_selector(".navbar #{form_selector} button[type='submit']")
      end
    end

    describe 'searching', elasticsearch: true do
      before { Profile.__elasticsearch__.refresh_index! }

      it 'displays profiles that are a partial match' do
        visit profiles_path(search: 'ada lovelace')

        expect(page).to have_content('Ada')
      end

      it 'displays profiles that are a partial match with more than one search input' do
        visit profiles_path(search: 'Marie')

        expect(page).to have_content('Curie')
      end

      it 'displays profiles that are a partial match with utf-8 characters' do
        visit profiles_path(search: 'könig')

        expect(page).to have_content('Christiane')
      end

      it 'displays profiles that have an empty space' do
        visit profiles_path(search: 'maren')

        expect(page).to have_content('Meier')
      end

      it 'displays "Filter by themes" prominently if no results' do
        visit profiles_path(search: 'asdfasdfasdf')

        expect(page).to have_xpath(filter_by_themes_xpath('filter-themes-next-line'))
        expect(page).to have_no_xpath(filter_by_themes_xpath('float-right'))
      end

      it 'displays "Filter by themes" discretely if results' do
        visit profiles_path(search: 'Marie')

        expect(page).to have_no_xpath(filter_by_themes_xpath('filter-themes-next-line'))
        expect(page).to have_xpath(filter_by_themes_xpath('float-right'))
      end

      it 'shows a tooltip when profile has data' do
        visit profiles_path(search: 'Marie')

        expect(page).to have_selector('[data-toggle="tooltip"]')
      end

      it 'shows no tooltip when profile has no data' do
        visit profiles_path(search: 'Phantom')

        expect(page).to have_no_selector('[data-toggle="tooltip"]')
      end
    end
  end

  describe 'admin area search', elasticsearch: true do
    let(:admin) { FactoryBot.create(:admin) }

    before do
      sign_in admin
      Profile.__elasticsearch__.refresh_index!
    end

    it 'finds the correct profile' do
      visit admin_profiles_path(search: 'ada lovelace')

      expect(page).to have_content('Lovelace')
    end
  end
end
