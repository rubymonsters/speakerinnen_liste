# frozen_string_literal: true

describe 'displaying tags' do
  let!(:locale_language_de) { create(:locale_language_de) }
  let!(:locale_language_en) { create(:locale_language_en) }

  let!(:tag_both_languages){ create(:tag_social_media, locale_languages: [locale_language_en, locale_language_de]) }
  let!(:tag_with_slash_en) { create(:tag, name: 'AC/DC', locale_languages: [locale_language_en]) }

  let!(:tag_de) { create(:tag_chemie, locale_languages: [locale_language_de]) }
  let!(:tag_en) { create(:tag_physics, locale_languages: [locale_language_en]) }
  let!(:tag_new) { create(:tag_fruehling, locale_languages: [locale_language_de]) }
  let!(:tag_with_unpublished_profile) { create(:tag, name: 'sports') }

  let!(:ada) do
    create(:published_profile, topic_list: [tag_en,
                                               tag_both_languages,
                                               tag_de,
                                               tag_with_slash_en])
  end
  let!(:pierre) { create(:unpublished_profile, topic_list: [tag_de, tag_with_unpublished_profile]) }

  it 'shows tagging after select tag in profile edit' do
    sign_in ada
    visit edit_profile_path(ada.id, locale: 'de')

    first('.select_tags', minimum: 1).select('fruehling')    
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
