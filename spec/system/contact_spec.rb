# frozen_string_literal: true

describe 'contact profile' do
  let!(:user) { FactoryBot.create(:published) }

  it 'should show the contact button' do
    visit profile_path(id: user.id)

    expect(page).to have_text(I18n.t(:contact, scope: 'profiles.show'))
    expect(page).to have_content('Factory Girl')
  end

  it 'fill the contact form correct and get a success message' do
    visit profile_path(id: user.id)

    fill_in I18n.t('.name', scope: 'contact.form'), with: 'Ada'
    fill_in I18n.t('.email', scope: 'contact.form'), with: 'Ada@email.de'
    fill_in I18n.t('.subject', scope: 'contact.form'), with: 'Need a speakerin'
    fill_in I18n.t('.body', scope: 'contact.form'), with: 'The conference ABC would like to invite you as a speakerin'
    click_button I18n.t('.send', scope: 'contact.form')

    expect(page).to have_content(I18n.t(:notice, scope: 'contact.form'))
  end

  it 'fills the contact form only with email' do
    visit profile_path(id: user.id)

    fill_in I18n.t('.email', scope: 'contact.form'), with: 'Ada@email.de'
    click_button I18n.t('.send', scope: 'contact.form')

    expect(page).to have_content(I18n.t(:error, scope: 'contact.form'))
  end
end
