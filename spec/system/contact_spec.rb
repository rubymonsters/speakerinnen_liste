# frozen_string_literal: true

describe 'contact profile' do
  let!(:ada) { FactoryBot.create(:ada) }

  context 'cookie consent is NOT set' do
    it 'contact button in profile should open hint modal' do
      visit profile_path(id: ada.id)
      within(:css, '.single-profile') do
        find("button[data-target='#contactHint']", match: :first)
      end
    end

    it 'contact button in footer should open hint modal' do
      visit profile_path(id: ada.id)

      within(:css, 'footer') do
        find("button[data-target='#contactHint']", match: :first)
        expect(page).to_not have_link('Contact', href: '/en/contact')
      end
    end

    it 'fill the contact form correct and not get a success message' do
      visit profile_path(id: ada.id)

      fill_in I18n.t('.name', scope: 'contact.form'), with: 'Ada'
      fill_in I18n.t('.email', scope: 'contact.form'), with: 'Ada@email.de'
      fill_in I18n.t('.subject', scope: 'contact.form'), with: 'Need a speakerin'
      fill_in I18n.t('.body', scope: 'contact.form'), with: 'The conference ABC would like to invite you as a speakerin'
      click_button I18n.t('.send', scope: 'contact.form')

      expect(page).to_not have_content(I18n.t(:notice, scope: 'contact.form'))
    end
  end

  context 'profile is inactive' do
    it 'contact button in profile should be renamed' do
      ada.update!(inactive: true)
      visit profile_path(id: ada.id)
      within(:css, '.single-profile') do
        expect(page).to have_button(ada.fullname + I18n.t(:no_contact, scope: 'profiles.show'))
      end
    end
  end

  context 'cookie consent is set' do
    it 'single profile should have a contact button when cookie consent is set' do
      visit profile_path(id: ada.id)
      find_link(class: 'cookie-consent').click
      find("button[data-target='#contactModal']", match: :first)
    end

    it 'footer should have a contact link when cookie consent is set' do
      visit profile_path(id: ada.id)
      find_link(class: 'cookie-consent').click

      expect(page).to have_link('Contact', href: '/en/contact')
    end

    it 'fill the contact form correct and get a success message' do
      visit profile_path(id: ada.id)

      find_link(class: 'cookie-consent').click
      find("button[data-target='#contactModal']", match: :first).click
      fill_in I18n.t('.name', scope: 'contact.form'), with: 'Ada'
      fill_in I18n.t('.email', scope: 'contact.form'), with: 'Ada@email.de'
      fill_in I18n.t('.subject', scope: 'contact.form'), with: 'Need a speakerin'
      fill_in I18n.t('.body', scope: 'contact.form'), with: 'The conference ABC would like to invite you as a speakerin'
      click_button I18n.t('.send', scope: 'contact.form')

      expect(page).to have_content(I18n.t(:notice, scope: 'contact.form'))
    end

    it 'fills the contact form only with email' do
      visit profile_path(id: ada.id)
      find_link(class: 'cookie-consent').click

      fill_in I18n.t('.email', scope: 'contact.form'), with: 'Ada@email.de'
      click_button I18n.t('.send', scope: 'contact.form')

      expect(page).to have_content(I18n.t(:error, scope: 'contact.form'))
    end

    it 'fills the contact form with spam email' do
      visit profile_path(id: ada.id)
      find_link(class: 'cookie-consent').click

      find("button[data-target='#contactModal']", match: :first).click
      fill_in I18n.t('.name', scope: 'contact.form'), with: 'Ada'
      fill_in I18n.t('.email', scope: 'contact.form'), with: 'fish@email.de'
      fill_in I18n.t('.subject', scope: 'contact.form'), with: 'Need a speakerin'
      fill_in I18n.t('.body', scope: 'contact.form'), with: 'The conference ABC would like to invite you as a speakerin'
      click_button I18n.t('.send', scope: 'contact.form')

      expect(page).to have_content(I18n.t(:error, scope: 'contact.form'))
    end
  end
end
