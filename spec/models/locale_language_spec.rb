describe LocaleLanguage, type: :model do
  let!(:locale_language_de) do
    FactoryGirl.create(:locale_language, iso_code: 'de')
  end

  let!(:locale_language_en) do
    FactoryGirl.create(:locale_language, iso_code: 'en')
  end

  let!(:tag_de) do
    ActsAsTaggableOn::Tag.create(
      name: 'Chemie',
      locale_languages: [locale_language_de]
    )
  end

  let!(:tag_en) do
    ActsAsTaggableOn::Tag.create(
      name: 'physics',
      locale_languages: [locale_language_en]
    )
  end

  let!(:tag_no_language){ ActsAsTaggableOn::Tag.create(name: 'mathematic') }
  let!(:tag_with_unpublished_profile){ ActsAsTaggableOn::Tag.create(name: 'sports') }

  let!(:tag_both_languages) do
    ActsAsTaggableOn::Tag.create(
      name: 'social media',
      locale_languages: [locale_language_de, locale_language_en]
    )
  end

  let!(:category_science){ Category.create(id: 1, name: "Science", tags: [tag_de, tag_en]) }
  let!(:category_XXX){ Category.create(id: 2, name: "XXX") }

  let!(:marie){ Profile.create(firstname: "Marie", lastname: "Curie", published: true, topic_list: [tag_de, tag_no_language],
                    password: "123foobar", password_confirmation: "123foobar", confirmed_at: Time.now, email: "marie@curie.fr") }
  let!(:pierre){ Profile.create(firstname: "Pierre", lastname: "Curie", published: false, topic_list: [tag_de, tag_with_unpublished_profile],
                    password: "123foobar", password_confirmation: "123foobar", confirmed_at: Time.now, email: "pierre@curie.fr") }
  let!(:ada){ Profile.create(firstname: "Ada", lastname: "Lovelace", published: true, topic_list: [tag_en, tag_both_languages],
                   password: "123foobar", password_confirmation: "123foobar", confirmed_at: Time.now, email: "ada@love.uk") }

  after(:all) do
    ActsAsTaggableOn::Tag.destroy_all
    LocaleLanguage.destroy_all
    Category.destroy_all
    Profile.destroy_all
  end

  it 'finds associated language of the tag' do
    expect(tag_de.locale_languages).to match_array([locale_language_de])
  end

  it 'finds associated tags for a language' do
    expect(locale_language_de.tags).to match_array([tag_de, tag_both_languages])
  end

  it 'adds a language to the existing tag' do
    expect(tag_de.locale_languages.first.iso_code).to eq('de')
  end

  describe 'scope languages' do
    it 'shows tags used by published profile' do
      expect(ActsAsTaggableOn::Tag.with_published_profile).to match_array([tag_de,
                                                                           tag_en,
                                                                           tag_both_languages,
                                                                           tag_no_language])
    end

    it 'shows tags that belong to a certain category' do
      expect(ActsAsTaggableOn::Tag.belongs_to_category(1)).to match_array([tag_de,
                                                                           tag_en])
    end

    it 'shows tags used by published profile that belong to a certain category' do
      expect(ActsAsTaggableOn::Tag.belongs_to_category(1).with_published_profile).to match_array([tag_de,
                                                                                                  tag_en])
    end

    it 'shows no tags used by published profile that do not belong to a certain category' do
      expect(ActsAsTaggableOn::Tag.belongs_to_category(2).with_published_profile).to be_empty
    end

    it 'shows tags used by published profile that belong to a certain category with language de' do
      expect(ActsAsTaggableOn::Tag.belongs_to_category(1).with_published_profile.with_language('de')).to match_array([tag_de])
    end

    it 'shows tags used by published profile that belong to a certain category with language en' do
      expect(ActsAsTaggableOn::Tag.belongs_to_category(1).with_published_profile.with_language('en')).to match_array([tag_en])
    end

    it 'shows tags used by published profile that belong to a certain category with no language'

    it 'shows tags used by published profile with language de or en'

    it 'shows tags used by published profile with language de'

    it 'shows tags used by published profile with language en'

    it 'shows tags used by published profile with no language'

    it 'shows tags used by published profile with language de or en'

    it 'shows tags used by a certain profile with no language'

    it 'shows tags used by a certain profile with language de' do
      expect(marie.topics.with_language('de')).to match_array([tag_de])
    end

    it 'shows tags used by a certain profile with language de and without language' do
      expect(marie.topics.with_language('de')).to match_array([tag_de])
      expect(marie.topics.without_language).to match_array([tag_no_language])
      topics_in_correct_language_and_without_any = []
      topics_in_correct_language_and_without_any << marie.topics.with_language('de')
      topics_in_correct_language_and_without_any << marie.topics.without_language
      expect(topics_in_correct_language_and_without_any.flatten.uniq).to match_array([tag_de, tag_no_language])
    end

    it 'shows tags used by a certain profile with language en' do
      expect(ada.topics.with_language('en')).to match_array([tag_en, tag_both_languages])
    end

    it 'shows tags used by a certain profile with language de or en' do
      expect(ada.topics.with_language(['de', 'en'])).to match_array([tag_en, tag_both_languages])
    end

    it 'shows tags with no language' do
      expect(ActsAsTaggableOn::Tag.with_language('')).to match_array([])
    end

    it 'shows tags with language de' do
      expect(ActsAsTaggableOn::Tag.with_language('de')).to match_array([tag_de, tag_both_languages])
    end

    it 'shows tags with language en' do
      expect(ActsAsTaggableOn::Tag.with_language('en')).to match_array([tag_en, tag_both_languages])
    end

    it 'shows tags with language de or en' do
      expect(ActsAsTaggableOn::Tag.with_language(['en','de'])).to match_array([tag_both_languages, tag_en, tag_de])
    end
  end
end
