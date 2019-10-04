# frozen_string_literal: true

describe 'displaying tags' do
  let!(:locale_language_de) { create(:locale_language_de) }
  let!(:locale_language_en) { create(:locale_language_en) }

  let!(:tag_both_languages){ create(:tag_social_media, locale_languages: [locale_language_en, locale_language_de]) }
  let!(:tag_with_slash_en) { create(:tag, name: 'AC/DC', locale_languages: [locale_language_en]) }

  let!(:tag_de) { create(:tag_chemie, locale_languages: [locale_language_de]) }
  let!(:tag_en) { create(:tag_physics, locale_languages: [locale_language_en]) }
  let!(:tag_with_unpublished_profile) { create(:tag, name: 'sports') }

  let!(:ada) do
    create(:published_profile, topic_list: [tag_en,
                                               tag_both_languages,
                                               tag_de,
                                               tag_with_slash_en])
  end
  let!(:pierre) { create(:unpublished_profile, topic_list: [tag_de, tag_with_unpublished_profile]) }

  it 'shows tagging after profile edit' do
    sign_in ada
    visit edit_profile_path(ada.id, locale: 'de')

    fill_in 'profile[topic_list]', with: 'fruehling'
    click_button 'Aktualisiere dein Profil'

    expect(page).to have_content('fruehling')
  end

  context "in the category index page" do

    it 'shows all the categories to coose the tags from'

    context 'in the tags box' do
      it 'shows the tags for the category you choose'
      it 'shows tags with no language'

      xit 'shows only german tags' do
        visit 'de/categories'
        within '#available-tags-box' do
          expect(page).to have_content('chemie')
          expect(page).not_to have_content('fruehling')
        end
      end

      xit 'shows only english tags' do
        visit 'en/categories'
        within '#available-tags-box' do
          expect(page).to have_content('physics')
          expect(page).not_to have_content('chemie')
        end
      end

      xit 'shows with slash use %2F for the link generating' do
        visit 'en/categories'
        within '#available-tags-box' do
          click_link('AC/DC')
        end
        expect(page).to have_content('AC/DC')
      end

      xit 'shows not tags from unpublished profiles' do
        visit 'en/categories'
        within '#available-tags-box' do
          expect(page).not_to have_content('sports')
        end
      end

    end
  end
end
