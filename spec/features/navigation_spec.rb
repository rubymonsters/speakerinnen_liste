RSpec.feature 'Navigation', type: :feature do
  context 'logged in' do
    before do
      sign_in user
    end

    after(:all) do
      ActsAsTaggableOn::Tag.destroy_all
      LocaleLanguage.destroy_all
      Profile.destroy_all
    end

    context 'as an admin' do
      let(:user) { FactoryGirl.create(:admin) }

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

        expect(page).to have_link('Categories', categorization_admin_tags_path)
        expect(page).to have_link('Tags', admin_categories_path)
        expect(page).to have_link('Profiles', admin_profiles_path)
      end

      context 'category abc' do
        before do
          FactoryGirl.create(:category, name: 'abc')
        end

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
        before do
          FactoryGirl.create(:profile, published: true)
          FactoryGirl.create(:admin, published: false)
        end

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

      scenario 'viewing edit tags in admin area' do
        visit admin_root_path

        click_link 'Tags'
        expect(page).to have_text('Administration::Tags')
        expect(page).to have_text('Search for tag')
        expect(page).to have_text('Here are 0 out of 0 tags')
        expect(page).to have_button('Filter')
      end

      scenario 'adding locale_language to tags' do
        tag = ActsAsTaggableOn::Tag.create(name: 'chemie')
        language_en = LocaleLanguage.create(iso_code: 'en')
        language_de = LocaleLanguage.create(iso_code: 'de')
        visit admin_root_path

        click_link 'Tags'
        expect(page).to have_text('chemie')
        find('.table').find('.vertical-top').find('.locale_language').find('#chemie_en').set(true)
        click_button 'Update Tag'
        expect(tag.locale_languages.first.iso_code).to eq('en')
      end
    end

    context 'as an unprivileged user' do
      let(:user) { FactoryGirl.create(:profile) }

      scenario 'shows no admin link' do
        visit root_path

        expect(page).to_not have_link('Admin')
      end

      scenario 'page has header' do
        visit root_path

        expect(page).to have_css('#header__logo')
        expect(page).to have_link('My profile')
        expect(page).to have_link('Log out')
        expect(page).to have_link('DE')
      end
    end
  end

  context 'guest user' do
    scenario 'page has header' do
      visit root_path

      expect(page).to have_css('#header__logo')
      expect(page).to have_link('Register as a speaker')
      expect(page).to have_link('Log in')
      expect(page).to have_link('DE')
    end

    scenario 'viewing the start page' do
      visit root_path

      expect(page).to have_css('#startpage__start-teaser')
      expect(page).to have_css('#startpage__teaser-bg-01')
      expect(page).to have_css('#startpage__teaser-bg-02')
    end

    scenario 'viewing the contact page' do
      visit root_path

      click_link 'Email'
      expect(page).to have_css('form label', text: 'Your name')
      expect(page).to have_css('form label', text: 'Your email address')
      expect(page).to have_css('form label', text: 'Subject')
      expect(page).to have_css('form label', text: 'Your message')

      expect(page).to have_button('Send')
    end
  end

  describe 'logging in' do
    context 'registered user' do
      before do
        FactoryGirl.create(:profile, email: 'ltest@exp.com', password: 'rightpassword', password_confirmation: 'rightpassword')
      end

      scenario 'successful login' do
        visit new_profile_session_path

        fill_in 'profile_email', with: 'ltest@exp.com'
        fill_in 'profile_password', with: 'rightpassword'

        click_button 'Sign in'

        expect(page).to have_css('.notice', text: 'Logged in successfully.')
      end

      scenario 'wrong password' do
        visit new_profile_session_path

        fill_in 'profile_email', with: 'ltest@exp.com'
        fill_in 'profile_password', with: 'wrongpassword'

        click_button 'Sign in'

        expect(page).to have_css('.alert', text: 'Invalid email or password.')
      end

      scenario 'empty password' do
        visit new_profile_session_path

        fill_in 'profile_email', with: 'ltest@exp.com'
        fill_in 'profile_password', with: ''

        click_button 'Sign in'

        expect(page).to have_css('.alert', text: 'Invalid email or password.')
      end

      scenario 'non-existing email' do
        visit new_profile_session_path

        fill_in 'profile_email', with: 'false@exp.com'
        fill_in 'profile_password', with: 'rightpassword'

        click_button 'Sign in'

        expect(page).to have_css('.alert', text: 'Invalid email or password.')
      end

      scenario 'empty email' do
        visit new_profile_session_path

        fill_in 'profile_email', with: ''
        fill_in 'profile_password', with: 'rightpassword'

        click_button 'Sign in'

        expect(page).to have_css('.alert', text: 'Invalid email or password.')
      end
    end
  end
end
