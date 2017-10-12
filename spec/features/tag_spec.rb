describe 'displaying tags' do
  before(:all) do
      @tag_both_languages = ActsAsTaggableOn::Tag.create(name: 'social media')
      @tag_both_languages.tag_languages << TagLanguage.new(language: 'de')
      @tag_both_languages.tag_languages << TagLanguage.new(language: 'en')

      @tag_with_slash_en = ActsAsTaggableOn::Tag.create(name: 'AC/DC')
      @tag_with_slash_en.tag_languages << TagLanguage.new(language: 'en')

      @tag_one_language_en = ActsAsTaggableOn::Tag.create(name: 'physics')
      @tag_one_language_en.tag_languages << TagLanguage.new(language: 'en')

      @tag_one_language_de = ActsAsTaggableOn::Tag.create(name: 'Chemie')
      @tag_one_language_de.tag_languages << TagLanguage.new(language: 'de')

      @tag_with_unpublished_profile = ActsAsTaggableOn::Tag.create(name: 'sports')
      @tag_with_unpublished_profile.tag_languages << TagLanguage.new(language: 'de')

      Profile.create(firstname: 'Pierre', lastname: 'Curie', published: false, topic_list: [@tag_one_language_de, @tag_with_unpublished_profile],
                      password: '123foobar', password_confirmation: '123foobar', confirmed_at: Time.now, email: 'pierre@curie.fr')
      @ada = Profile.create(firstname: 'Ada', lastname: 'Lovelace', published: true, main_topic_en: 'first computer programm',
                            bio_en: 'first programmer', main_topic_de: 'Erstes Computer-Programm', bio_de: 'Erste Programmiererin',
                            topic_list: [@tag_one_language_de, @tag_one_language_en, @tag_both_languages, @tag_with_slash_en], password: '123foobar', password_confirmation: '123foobar',
                            confirmed_at: Time.now, email: 'ada@love.uk')
  end

  after(:all) do
    ActsAsTaggableOn::Tag.destroy_all
    TagLanguage.destroy_all
    Profile.destroy_all
  end

  it 'shows tagging after profile edit' do
    sign_in @ada
    visit edit_profile_path(@ada.id, locale: 'de')

    fill_in 'profile[topic_list]', with: 'fruehling'
    click_button 'Aktualisiere dein Profil'

    expect(page).to have_content('fruehling')
  end

  it 'shows only german tags in topic cloud' do
    visit 'de/profiles'
    within '.topics-cloud' do
      expect(page).to have_content('Chemie')
      expect(page).not_to have_content('fruehling')
    end
  end

  it 'shows only english tags in topic cloud' do
    visit 'en/profiles'
    within '.topics-cloud' do
      expect(page).to have_content('physics')
      expect(page).not_to have_content('Chemie')
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
