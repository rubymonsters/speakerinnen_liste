describe 'set locale_language' do
  let!(:admin) { Profile.create!(FactoryGirl.attributes_for(:admin)) }

  before(:each) do
    sign_in admin
    visit admin_root_path
    click_link I18n.t(:tags, scope: 'admin.dashboard.tags')
  end

  before(:all) do
    @localelanguage_en = LocaleLanguage.create!(iso_code: 'en')
    @localelanguage_de = LocaleLanguage.create!(iso_code: 'de')
  end

  after(:all) do
    ActsAsTaggableOn::Tag.destroy_all
    LocaleLanguage.destroy_all
    Profile.destroy_all
  end

  describe "with several tags" do

    before(:all) do
      @tag_both_languages = ActsAsTaggableOn::Tag.create!(name: 'social media')
      @tag_both_languages.locale_languages << @localelanguage_de
      @tag_both_languages.locale_languages << @localelanguage_en

      @tag_with_slash_en = ActsAsTaggableOn::Tag.create!(name: 'AC/DC')

      @tag_one_language_en = ActsAsTaggableOn::Tag.create!(name: 'physics')

      @tag_with_unpublished_profile = ActsAsTaggableOn::Tag.create!(name: 'sports')
      @tag_with_unpublished_profile.locale_languages << @localelanguage_en
    end

    after(:all) do
      ActsAsTaggableOn::Tag.destroy_all
    end

    scenario 'viewing edit tags in admin area' do

      visit admin_root_path

      click_link 'Tags'
      expect(page).to have_text('Administration::Tags')
      expect(page).to have_text('Search for tag')
      expect(page).to have_button('Filter')
    end

    scenario 'correct locale language are set to the tags' do
      expect(page).to have_content('AC/DC')
      expect(page).to_not have_checked_field("sports_de")
      expect(page).to have_checked_field("sports_en")
      expect(page).to have_checked_field("social media_en")
      expect(page).to have_checked_field("social media_de")
    end
  end

  describe "with one tag" do

    after(:all) do
      ActsAsTaggableOn::Tag.destroy_all
    end

    scenario 'adding locale_language to tags' do
      tag_chemie = ActsAsTaggableOn::Tag.create!(name: 'chemie')
      visit admin_root_path

      click_link 'Tags'
      expect(page).to have_text('chemie')
      expect(page).to_not have_checked_field("chemie_en")
      check 'chemie_en'
      click_button 'Update Tag'
      expect(tag_chemie.locale_languages.first.iso_code).to eq('en')
    end
  end
end
