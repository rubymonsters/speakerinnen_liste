# frozen_string_literal: true

RSpec.describe 'Navigation', type: :system do
  context 'logged in as an admin' do
    let!(:admin) { FactoryBot.create(:admin) }

    before do
      sign_in admin
      visit root_path
    end

    it 'shows admin link' do
      expect(page).to have_link('Admin')
    end

    it 'page has header' do
      expect(page).to have_link I18n.t('layouts.application.logout')
      expect(page).to have_css('#header__logo')
      expect(page).to have_link('My profile')
      expect(page).to have_link('Log out')
      expect(page).to have_link('Admin')
      expect(page).to have_link('DE')
    end

    it 'navigating to admin page' do
      click_link 'Admin'
      expect(page).to have_text('Administration')

      expect(page).to have_link('Categories', href: '/en/admin/categories')
      expect(page).to have_link('Tags', href: '/en/admin/tags/index')
      expect(page).to have_link('Profiles', href: '/en/admin/profiles')
      expect(page).to have_link('Features', href: '/en/admin/features')
    end

    context 'category' do
      let!(:category) { FactoryBot.create(:cat_science) }

      it 'viewing categories index in admin area' do
        visit admin_root_path

        click_link 'Categories'
        expect(page).to have_text('Administration::Categories')
        expect(page).to have_link('Add')
        expect(page).to have_link('Edit')
        expect(page).to have_link('Delete')
        expect(page).to have_css('.categories > thead > tr', text: 'German:')
        expect(page).to have_css('.categories > thead > tr', text: 'English:')
        expect(page).to have_text('Science')
      end

      it 'viewing edit category in admin area' do
        visit admin_categories_path

        click_link 'Edit'

        expect(page).to have_text('Administration::Categories::Edit')
        expect(page).to have_button('Save')

        expect(page).to have_text('Enter new category name in German:')
        expect(page).to have_text('Enter new category name in English:')
      end

      it 'view add category in admin area' do
        visit admin_categories_path

        click_link 'Add'
        expect(page).to have_text('Administration::Categories::Add')
        expect(page).to have_text('Enter new category name in German:')
        expect(page).to have_text('Enter new category name in English:')
        expect(page).to have_button('Add')
      end
    end # context categories

    context 'profiles' do
      let!(:ada) { create(:ada, topic_list: 'algorithm') }
      let!(:marie) { FactoryBot.create(:unpublished_profile, firstname: 'Marie') }
      let!(:rosa) { FactoryBot.create(:unconfirmed_profile, firstname: 'Rosa') }

      before do
        FactoryBot.create(:medialink,
                      profile_id: ada.id,
                      title: 'Ada and the computer',
                      url: 'www.adalovelace.de',
                      description: 'How to programm')
        visit admin_root_path
        click_link 'Profiles'
      end

      context 'index view' do
        it 'shows profiles' do
          expect(page).to have_text('Administration::Profiles')
          expect(page).to have_link('public')
          expect(page).to have_link('invisible')

          expect(page).to have_css('.table > thead > tr', text: 'ID')
          expect(page).to have_css('.table > thead > tr', text: 'Speakerinnen')
          expect(page).to have_css('.table > thead > tr', text: 'Created')
          expect(page).to have_css('.table > thead > tr', text: 'Updated')
          expect(page).to have_css('.table > thead > tr', text: 'Links')
          expect(page).to have_css('.table > thead > tr', text: 'Image')
          expect(page).to have_css('.table > thead > tr', text: 'Visibility')
          expect(page).to have_css('.table > thead > tr', text: 'Roles')
          expect(page).to have_css('.table > thead > tr', text: 'Comment')

          expect(page).to have_button('Add comment')
        end

        it 'shows published and unpublished but not the unconfirmed profiles' do
          expect(page).to have_content('Ada')
          expect(page).to have_content('Marie')
          expect(page).not_to have_content('Rosa')
        end
      end

      context 'show view' do
        it 'show single profile with the correct content' do
          click_on 'Ada Lovelace'

          expect(page).to have_content('Ada')
          expect(page).to have_content('Lovelace')
          expect(page).to have_content('@alove')
          expect(page).to have_content('London')
          expect(page).to have_content('She published the first algorithm for a machine.')
          expect(page).to have_content('math')
          expect(page).to have_content('algorithm')
          expect(page).to have_content('English')
          expect(page).to have_content('German')
          expect(page).to have_link('Ada and the computer', href: 'https://www.adalovelace.de')
          expect(page).to have_content('How to programm')
        end
      end

      context 'edit view' do
        it 'viewing profile edit in admin area' do
          click_on 'Ada Lovelace'
          click_link 'Edit', match: :first
          expect(page).to have_text('Administration::Profiles::Edit')
          expect(page).to have_button('Update your profile')
          expect(page).to have_link('Show profile')
          expect(page).to have_link('List all profiles')

          expect(page).to have_css('div.profile_firstname')
          expect(page).to have_css('div.profile_lastname')
          expect(page).to have_css('#twitter_en')
          expect(page).to have_css('#city_en')
          expect(page).to have_css('div.profile_iso_languages')
          expect(page).to have_css('#profile_website_de')
          expect(page).to have_css('#profile_website_2_de')
          expect(page).to have_css('#profile_website_3_de')
          expect(page).to have_css('div.profile_topic_list')
          expect(page).to have_css('form label', text: 'country')
          expect(page).to have_css('form label', text: 'picture')
          expect(page).to have_css('form label', text: 'Main focus in German')
          expect(page).to have_css('form label', text: 'My bio in German')
          expect(page).to have_css('form label', text: 'Main focus in English')
          expect(page).to have_css('form label', text: 'My bio in English')
        end
      end
    end # context profiles
  end
end
