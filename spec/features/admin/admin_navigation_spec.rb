RSpec.feature 'Navigation', type: :feature do
  context 'logged in as an admin' do
    let!(:admin) { FactoryBot.create(:admin) }

    before do
      sign_in admin
    end

    scenario 'shows admin link' do
      visit root_path

      expect(page).to have_link('Admin')
    end

    scenario 'page has header' do
      visit root_path

      expect(page).to have_css('#header__logo')
      expect(page).to have_link('My profile')
      expect(page).to have_link('Log out')
      expect(page).to have_link('Admin')
      expect(page).to have_link('DE')
    end

    scenario 'navigating to admin page' do
      visit root_path

      click_link 'Admin'
      expect(page).to have_text('Administration')

      expect(page).to have_link('Categories', admin_tags_path)
      expect(page).to have_link('Tags', admin_categories_path)
      expect(page).to have_link('Profiles', admin_profiles_path)
    end

    context 'category' do
      let!(:category) { FactoryBot.create(:cat_science) }

      scenario 'viewing edit categories in admin area' do
        visit admin_root_path

        click_link 'Categories'

        expect(page).to have_text('Administration::Categories')
        expect(page).to have_link('Add')
        expect(page).to have_link('Edit')
        expect(page).to have_link('Delete')

        expect(page).to have_css('.categories > thead > tr', text: 'German:')
        expect(page).to have_css('.categories > thead > tr', text: 'English:')
      end

      scenario 'viewing edit "abc" category in admin area' do
        visit admin_categories_path

        click_link 'Edit'

        expect(page).to have_text('Administration::Categories::Edit')
        expect(page).to have_button('Save')

        expect(page).to have_text('Enter new category name in German:')
        expect(page).to have_text('Enter new category name in English:')
      end

      scenario 'view add category in admin area' do
        visit admin_categories_path

        click_link 'Add'
        expect(page).to have_text('Administration::Categories::Add')
        expect(page).to have_text('Enter new category name in German:')
        expect(page).to have_text('Enter new category name in English:')
        expect(page).to have_button('Add')
      end
    end

    context 'two profiles' do
      let!(:user) { FactoryBot.create(:published) }

      scenario 'viewing edit profiles in admin area' do
        visit admin_root_path

        click_link 'Profiles'
        expect(page).to have_text('Administration::Profiles')
        expect(page).to have_link('public')
        expect(page).to have_link('invisible')

        expect(page).to have_css('.profiles > thead > tr', text: 'Speakerinnen')
        expect(page).to have_css('.profiles > thead > tr', text: 'Created')
        expect(page).to have_css('.profiles > thead > tr', text: 'Updated')
        expect(page).to have_css('.profiles > thead > tr', text: 'Media')
        expect(page).to have_css('.profiles > thead > tr', text: 'Links')
        expect(page).to have_css('.profiles > thead > tr', text: 'Visibility')
        expect(page).to have_css('.profiles > thead > tr', text: 'Roles')
        expect(page).to have_css('.profiles > thead > tr', text: 'Comment')

        expect(page).to have_button('Add comment')
      end
    end

    scenario 'viewing profile edit in admin area' do
      visit admin_profiles_path

      click_link 'Edit'
      expect(page).to have_text('Administration::Profiles::Edit')
      expect(page).to have_button('Update your profile')
      expect(page).to have_link('Show profile')
      expect(page).to have_link('List all profiles')

      expect(page).to have_css('div.profile_firstname')
      expect(page).to have_css('div.profile_lastname')
      expect(page).to have_css('.profile_twitter')
      expect(page).to have_css('#city_en')
      expect(page).to have_css('div.profile_iso_languages')
      expect(page).to have_css('.profile_website')
      expect(page).to have_css('div.profile_topic_list')
      expect(page).to have_css('form label', text: 'country')
      expect(page).to have_css('form label', text: 'picture')
      expect(page).to have_css('form label', text: 'My main topic in German')
      expect(page).to have_css('form label', text: 'My bio in German')
      expect(page).to have_css('form label', text: 'My main topic in English')
      expect(page).to have_css('form label', text: 'My bio in English')
    end
  end
end
