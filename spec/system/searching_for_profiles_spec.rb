# frozen_string_literal: true

require 'spec_helper'

form_selector = 'form[action="/en/profiles"][method="get"]'

describe 'profile search' do
  let!(:locale_language_en) { create(:locale_language_en) }
  let!(:physics) { create(:tag_physics, locale_languages: [locale_language_en]) }
  let!(:algorithm) { create(:tag_algorithm, locale_languages: [locale_language_en]) }
  let!(:ada) { create(:ada, topic_list: [algorithm]) }
  let!(:marie) { create(:marie, topic_list: [physics]) }
  let!(:science) {create(:cat_science)}
  let!(:social) {create(:cat_social)}
  let!(:phantom_of_the_opera) { create(:phantom_of_the_opera, topic_list: []) }
  let!(:profile2) { create(:published_profile, firstname: 'Christiane', lastname: 'König', main_topic_en: 'Blogs') }
  let!(:profile3) { create(:published_profile, firstname: 'Maren ', lastname: 'Meier', main_topic_en: 'Big Data') }
  let!(:profile_not_matched) { create(:published_profile, firstname: 'Angela', main_topic_en: 'rassism' ) }
  let!(:unpublished_profile) { create(:unpublished_profile, firstname: 'May', main_topic_en: 'poetry' ) }

  describe 'public search' do
    context 'home page search form' do
      before { visit root_path }

      it 'shows autofill search input' do
        expect(page).to have_selector(".container #{form_selector} input#home_search.typeahead[type='search']")
      end

      it 'shows button search' do
        expect(page).to have_selector(".container #{form_selector} button[type='submit']")
      end
    end

    describe 'searching' do
      it 'displays profiles with searched topic' do
        visit profiles_path(search: 'physics')

        expect(page).to have_content('Marie')
      end

      it 'displays profiles with searched main topic' do
        visit profiles_path(search: 'Big Data')

        expect(page).to have_content('Maren')
      end

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

      it 'displays link to the "Filter by themes" prominently if no results' do
        visit profiles_path(search: 'asdfasdfasdf')

        expect(page).to have_link(href: /profiles/)
      end

      it 'shows a tooltip when profile has data' do
        visit profiles_path(search: 'Marie')

        expect(page).to have_selector('[data-toggle="tooltip"]')
      end

      it 'shows no tooltip when profile has no data' do
        visit profiles_path(search: 'Phantom')

        expect(page).to have_no_selector('[data-toggle="tooltip"]')
      end

      it 'displays correct data in aggregated filters' do
        visit profiles_path(search: 'physics', locale: 'en')

        expect(page).to have_selector('#facet_states')
        within '#facet_countries' do
          expect(page).to have_content('France')
        end
        within '#facet_cities' do
          expect(page).to have_content('Paris')
        end
        within '#facet_languages' do
          expect(page).to have_content('English')
          expect(page).to have_content('Polish')
        end
      end

      it 'does not return unpublished profiles' do
        visit profiles_path(search: 'poetry')

        expect(page).to have_content('Unfortuantely we have found no speakerin matching your search')
      end
    end
  end

  describe 'search by category' do
    it 'shows the correct profiles per category' do
      physics.categories << science
      algorithm.categories << science
      visit profiles_path(category_id: science.id)

      expect(page).to have_content('Marie')
      expect(page).to have_content('Ada')
      expect(page).to have_no_content('Maren')
    end

    it 'highlights the expexted category' do
      physics.categories << science
      algorithm.categories << science
      visit profiles_path(category_id: science.id)

      expect(page).to have_selector('#v-pills-science-tab.active')
    end
  end

  describe 'search by tags' do
    it 'shows the correct profiles per tag with one tag' do
      algorithm.categories << science
      physics.categories << social
      visit profiles_path(tag_filter: algorithm.name)

      expect(page).to have_content('Ada')
      expect(page).to_not have_content('Marie')
    end

    it 'shows the correct profiles per tag with two tags' do
      algorithm.categories << science
      physics.categories << science
      visit profiles_path(tag_filter: "#{algorithm.name},#{physics.name}")

      expect(page).to have_content('Marie')
      expect(page).to have_content('Ada')
    end

    it 'shows the correct profiles per tag with two tags from 2 different categories' do
      algorithm.categories << science
      physics.categories << social
      visit profiles_path(tag_filter: "#{algorithm.name},#{physics.name}")

      expect(page).to have_content('Marie')
      expect(page).to have_content('Ada')
    end
  end

  describe 'admin area search' do
    let(:admin) { FactoryBot.create(:admin) }

    before { sign_in admin }

    it 'finds the correct profile' do
      visit admin_profiles_path(search: 'ada lovelace')

      expect(page).to have_content('Lovelace')
    end
  end
end
