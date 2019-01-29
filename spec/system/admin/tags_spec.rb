# frozen_string_literal: true

describe 'in tags' do
  let!(:admin) { FactoryBot.create(:admin) }

  let!(:locale_language_de) { FactoryBot.create(:locale_language_de) }
  let!(:locale_language_en) { FactoryBot.create(:locale_language_en) }

  let!(:tag_chemie) { FactoryBot.create(:tag_chemie) }
  let!(:tag_physics) { FactoryBot.create(:tag_physics) }

  before do
    create(:ada, topic_list: [tag_physics, tag_chemie])
    create(:marie, topic_list: [tag_physics, tag_chemie])
    sign_in admin
    visit admin_root_path
    click_link I18n.t(:tags, scope: 'admin.dashboard.tags')
  end

  it 'adding locale_language to tags' do
    click_link tag_chemie.name
    expect(page).to have_selector("input[value='chemie']")
    expect(page).to_not have_checked_field("#{tag_chemie.id}_en")
    expect(page).to_not have_checked_field("#{tag_chemie.id}_de")
    check "#{tag_chemie.id}_en"
    click_button 'Save'
    expect(page.html).to include('English<br/>')
    expect(page.html).to_not include('German<br/>')
    expect(tag_chemie.locale_languages.first.iso_code).to eq('en')
  end

  it 'shows all tags' do
    expect(page).to have_content('physics')
    expect(page).to have_content('chemie')
  end

  it 'shows section to filter categories' do
    expect(page).to have_css('.filter_categories')
  end

  it 'shows section to filter languages' do
    expect(page).to have_css('.filter_languages')
  end

  it 'should have checkboxes to filter languages' do
    expect(page).to have_css('input[type="checkbox"]')
  end
end
