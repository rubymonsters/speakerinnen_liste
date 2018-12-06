# frozen_string_literal: true

describe 'show locale_language' do
  let!(:admin) { create(:admin) }
  let!(:locale_language_de) { create(:locale_language_de) }
  let!(:locale_language_en) { create(:locale_language_en) }
  let!(:tag_en) { create(:tag_physics, locale_languages: [locale_language_en]) }
  let!(:tag_with_slash_en) do
    create(:tag, name: 'AC/DC', locale_languages: [locale_language_en])
  end

  before(:each) do
    sign_in admin
    visit admin_root_path
    click_link I18n.t(:tags, scope: 'admin.dashboard.tags')
  end

  it 'views edit tags in admin area' do
    expect(page).to have_text('Administration::Tags')
    expect(page).to have_text('Search for tag')
    expect(page).to have_button('Filter')
  end

  it 'presents correct locale language for a tags' do
    expect(page).to have_content('AC/DC')
    expect(page.html).to include('English<br/>')
    expect(page.html).to_not include('German<br/>')
  end
end
