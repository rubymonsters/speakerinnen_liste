# frozen_string_literal: true

describe 'locale_language' do
  let!(:admin) { FactoryBot.create(:admin) }

  let!(:locale_language_de) { FactoryBot.create(:locale_language_de) }
  let!(:locale_language_en) { FactoryBot.create(:locale_language_en) }

  let!(:tag_chemie) { FactoryBot.create(:tag_chemie) }

  before(:each) do
    sign_in admin
    visit admin_root_path
    click_link I18n.t(:tags, scope: 'admin.dashboard.tags')
  end

  it 'adding locale_language to tags' do
    expect(page).to have_text('chemie')
    expect(page).to_not have_checked_field('chemie_en')
    expect(page).to_not have_checked_field('chemie_de')
    check 'chemie_en'
    click_button 'Save'
    expect(page).to have_checked_field('chemie_en')
    expect(tag_chemie.locale_languages.first.iso_code).to eq('en')
  end
end
