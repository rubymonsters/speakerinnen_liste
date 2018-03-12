describe 'show locale_language' do
  let!(:admin) { FactoryBot.create(:admin) }

  let!(:locale_language_de) { FactoryBot.create(:locale_language_de) }
  let!(:locale_language_en) { FactoryBot.create(:locale_language_en) }

  let!(:tag_both_lang) do
    FactoryBot.create(:tag_social_media,
                       locale_languages: [locale_language_en, locale_language_de])
  end
  let!(:tag_en) do
    FactoryBot.create(:tag_physics,
                       locale_languages: [locale_language_en])
  end
  let!(:tag_with_slash_en) do
    FactoryBot.create(:tag,
                       name: 'AC/DC',
                       locale_languages: [locale_language_en])
  end

  before(:each) do
    sign_in admin
    visit admin_root_path
    click_link I18n.t(:tags, scope: 'admin.dashboard.tags')
  end

  it 'viewing edit tags in admin area' do
    expect(page).to have_text('Administration::Tags')
    expect(page).to have_text('Search for tag')
    expect(page).to have_button('Filter')
  end

  it 'correct locale language are set to the tags' do
    expect(page).to have_content('AC/DC')
    expect(page).to_not have_checked_field('physics_de')
    expect(page).to have_checked_field('physics_en')
    expect(page).to have_checked_field('social media_en')
    expect(page).to have_checked_field('social media_de')
  end
end
