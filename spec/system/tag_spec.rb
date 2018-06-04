describe 'displaying tags' do
  let!(:locale_language_de) { FactoryBot.create(:locale_language_de) }
  let!(:locale_language_en) { FactoryBot.create(:locale_language_en) }

  let!(:tag_both_languages) do
    FactoryBot.create(:tag_social_media,
                       locale_languages: [locale_language_en, locale_language_de])
  end
  let!(:tag_with_slash_en) do
    FactoryBot.create(:tag, name: 'AC/DC', locale_languages: [locale_language_en])
  end

  let!(:tag_de) { FactoryBot.create(:tag_chemie, locale_languages: [locale_language_de]) }
  let!(:tag_en) { FactoryBot.create(:tag_physics, locale_languages: [locale_language_en]) }
  let!(:tag_with_unpublished_profile) { FactoryBot.create(:tag, name: 'sports') }

  let!(:ada) do
    FactoryBot.create(:published, topic_list: [tag_en,
                                                tag_both_languages,
                                                tag_de,
                                                tag_with_slash_en])
  end
  let!(:pierre) { create(:unpublished, topic_list: [tag_de, tag_with_unpublished_profile]) }

  it 'shows tagging after profile edit' do
    sign_in ada
    visit edit_profile_path(ada.id, locale: 'de')

    fill_in 'profile[topic_list]', with: 'fruehling'
    click_button 'Aktualisiere dein Profil'

    expect(page).to have_content('fruehling')
  end

  it 'shows only german tags in topic cloud' do
    visit 'de/profiles'
    within '.topics-cloud' do
      expect(page).to have_content('chemie')
      expect(page).not_to have_content('fruehling')
    end
  end

  it 'shows only english tags in topic cloud' do
    visit 'en/profiles'
    within '.topics-cloud' do
      expect(page).to have_content('physics')
      expect(page).not_to have_content('chemie')
    end
  end

  it 'shows tags with a blank' do
    visit '/profiles'
    assert page.has_content?('social media')
    within '.topics-cloud' do
      expect(page).to have_content('social media')
    end
  end

  it 'shows with slash use %2F for the link generating in profiles show' do
    visit 'en/profiles'
    within '.topics-cloud' do
      click_link('AC/DC')
    end
    expect(page).to have_content('AC/DC')
  end

  it 'shows not tags from unpublished profiles' do
    visit 'en/profiles'
    within '.topics-cloud' do
      expect(page).not_to have_content('sports')
    end
  end
end
