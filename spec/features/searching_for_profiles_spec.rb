require 'spec_helper'

describe 'profile search' do
  let!(:profile) do
    FactoryGirl.create(:published, firstname: 'Ada', lastname: 'Lovelace',
                                      twitter: 'alovelace', city: 'London',
                                      country: 'GB',
                                      iso_languages: ['en'],
                                      topic_list: %w[computer algorithms],
                                      bio_de: 'Ada:Das ist meine deutsche Bio.',
                                      bio_en: 'Ada:This is my english bio.',
                                      main_topic_de: 'Das Leben', main_topic_en: 'Life',
                                      email: 'info@example.com')
  end

  let!(:profile1) do
    FactoryGirl.create(:published, firstname: 'Maria', lastname: 'Curie',
                                      twitter: '', city: 'Paris',
                                      country: 'FR',
                                      iso_languages: %w[en fr],
                                      topic_list: %w[physicist chemist],
                                      bio_de: 'Maria: Das ist meine deutsche Bio.',
                                      bio_en: 'Maria: This is my english bio.',
                                      main_topic_de: 'x-ray', main_topic_en: 'Röntgen',
                                      email: 'maria@example.com')
  end
  #
  let!(:profile2) { FactoryGirl.create(:published, firstname: 'Christiane', lastname: 'König', city: 'Heidelberg', languages: 'German') }
  let!(:profile3) { FactoryGirl.create(:published, firstname: 'Maren ', lastname: 'Meier') }

  let!(:profile_not_matched) { FactoryGirl.create(:published, firstname: 'Angela', city: 'New York', twitter: '@adavis') }

  describe 'public search', elasticsearch: true do
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
    #       fill_in 'search', with: 'König'
    #       click_button I18n.t(:search, scope: 'pages.home.search')
    #       expect(page).to have_content('Christiane')
    #     end

    #     it 'displays profiles that have an empty space' do
    #       visit root_path
    #       fill_in 'search_quick', with: 'Maren Meier'
    #       click_button I18n.t(:search, scope: 'pages.home.search')
    #       expect(page).to have_content('Meier')
    #     end
  end

  # describe 'search in admin area' do
  #   before do
  #     sign_in admin
  #   end
  #   let(:admin) { FactoryGirl.create(:admin) }

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
