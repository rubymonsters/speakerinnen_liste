describe 'set locale_language' do
  let!(:admin) { Profile.create!(FactoryGirl.attributes_for(:admin)) }

  before(:each) do
    sign_in admin
    visit admin_root_path
    click_link I18n.t(:tags, scope: 'admin.dashboard.tags')
  end

  before(:all) do

    @localelanguage_en = LocaleLanguage.new(iso_code: 'en')
    @localelanguage_de = LocaleLanguage.new(iso_code: 'de')

    @tag_both_languages = ActsAsTaggableOn::Tag.create!(name: 'social media')
    @tag_both_languages.locale_languages << @localelanguage_de
    @tag_both_languages.locale_languages << @localelanguage_en

    @tag_with_slash_en = ActsAsTaggableOn::Tag.create!(name: 'AC/DC')

    @tag_one_language_en = ActsAsTaggableOn::Tag.create!(name: 'physics')

    @tag_one_language_de = ActsAsTaggableOn::Tag.create!(name: 'Chemie')

    @tag_with_unpublished_profile = ActsAsTaggableOn::Tag.create!(name: 'sports')
    @tag_with_unpublished_profile.locale_languages << @localelanguage_en

    Profile.create!(firstname: 'Pierre', lastname: 'Curie', published: false, topic_list: [@tag_one_language_de, @tag_with_unpublished_profile],
                    password: '123foobar', password_confirmation: '123foobar', confirmed_at: Time.now, email: 'pierre@curie.fr')
    Profile.create!(firstname: 'Ada', lastname: 'Lovelace', published: true, main_topic_en: 'first computer programm',
                          bio_en: 'first programmer', main_topic_de: 'Erstes Computer-Programm', bio_de: 'Erste Programmiererin',
                          topic_list: [@tag_one_language_de, @tag_one_language_en, @tag_both_languages, @tag_with_slash_en], password: '123foobar', password_confirmation: '123foobar',
                          confirmed_at: Time.now, email: 'ada@love.uk')
  end

  after(:all) do
    ActsAsTaggableOn::Tag.destroy_all
    LocaleLanguage.destroy_all
    Profile.destroy_all
  end

  it 'correct locale language are set to the tags' do
    expect(page).to have_content('AC/DC')
    expect(page).to_not have_checked_field("sports_de")
    expect(page).to have_checked_field("sports_en")
    expect(page).to have_checked_field("social media_en")
    expect(page).to have_checked_field("social media_de")
  end

  it 'adds locale language to the tags' do
    expect(page).to_not have_checked_field("physics_en")
    expect(page).to_not have_checked_field("physics_de")
    check 'physics_en'
    expect(page).to have_checked_field("physics_en")
  end

  it 'adds 2 locale languages to the tags' do
    expect(page).to_not have_checked_field("AC/DC_en")
    expect(page).to_not have_checked_field("AC/DC_de")
    check 'AC/DC_en'
    check 'AC/DC_de'
    expect(page).to have_checked_field("AC/DC_en")
    expect(page).to have_checked_field("AC/DC_de")
  end
end
