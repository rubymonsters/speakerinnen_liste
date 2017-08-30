describe TagLanguage, :type => :model do
  before(:all) do
    @tag_both_languages = ActsAsTaggableOn::Tag.create(name: 'social media')
    @tag_both_languages.tag_languages << TagLanguage.new(language: "de")
    @tag_both_languages.tag_languages << TagLanguage.new(language: "en")

    @tag_no_language = ActsAsTaggableOn::Tag.create(name: 'mathematic')

    @tag_one_language_en = ActsAsTaggableOn::Tag.create(name: 'physics')
    @tag_one_language_en.tag_languages << TagLanguage.new(language: "en")

    @tag_one_language_de = ActsAsTaggableOn::Tag.create(name: 'Chemie')
    @tag_one_language_de.tag_languages << TagLanguage.new(language: "de")

    @tag_with_unpublished_profile = ActsAsTaggableOn::Tag.create(name: 'sports')

    Category.create(id: 1, name: "Science", tags: [@tag_one_language_de, @tag_one_language_en])
    Category.create(id: 2, name: "XXX")

    @marie = Profile.create(firstname: "Marie", lastname: "Curie", published: true, topic_list: [@tag_one_language_de, @tag_no_language],
                    password: "123foobar", password_confirmation: "123foobar", confirmed_at: Time.now, email: "marie@curie.fr")
    Profile.create(firstname: "Pierre", lastname: "Curie", published: false, topic_list: [@tag_one_language_de, @tag_with_unpublished_profile],
                    password: "123foobar", password_confirmation: "123foobar", confirmed_at: Time.now, email: "pierre@curie.fr")
    @ada = Profile.create(firstname: "Ada", lastname: "Lovelace", published: true, topic_list: [@tag_one_language_en, @tag_both_languages],
                   password: "123foobar", password_confirmation: "123foobar", confirmed_at: Time.now, email: "ada@love.uk")
  end

  after(:all) do
    ActsAsTaggableOn::Tag.destroy_all
    Category.destroy_all
  end

  it 'adds a language to the existing tag' do
    expect(@tag_both_languages.tag_languages.first.language).to eq('de')
  end

  it 'should only allow available locales as language' do
    record = TagLanguage.new(tag_id: 1, language: 'fr')
    record.valid?

    expect(record.errors[:language]).to include("fr is not a valid language")
  end

  describe 'scope languages' do

    it "shows tags used by published profile" do
      expect(ActsAsTaggableOn::Tag.with_published_profile).to match_array([@tag_one_language_de,
                                                                           @tag_one_language_en,
                                                                           @tag_both_languages,
                                                                           @tag_no_language])
    end

    it "shows tags that belong to a certain category" do
      expect(ActsAsTaggableOn::Tag.belongs_to_category(1)).to match_array([@tag_one_language_de,
                                                                           @tag_one_language_en])
    end

    it "shows tags used by published profile that belong to a certain category" do
      expect(ActsAsTaggableOn::Tag.belongs_to_category(1).with_published_profile).to match_array([@tag_one_language_de,
                                                                                                  @tag_one_language_en])
    end

    it "shows no tags used by published profile that don't belong to a certain category" do
      expect(ActsAsTaggableOn::Tag.belongs_to_category(2).with_published_profile).to be_empty
    end

    it "shows tags used by published profile that belong to a certain category with language 'de'" do
      expect(ActsAsTaggableOn::Tag.belongs_to_category(1).with_published_profile.with_language('de')).to match_array([@tag_one_language_de])
    end

    it "shows tags used by published profile that belong to a certain category with language 'en'" do
      expect(ActsAsTaggableOn::Tag.belongs_to_category(1).with_published_profile.with_language('en')).to match_array([@tag_one_language_en])
    end

    it "shows tags used by published profile that belong to a certain category with no language"

    it "shows tags used by published profile with language 'de' or 'en'"

    it "shows tags used by published profile with language 'de'"

    it "shows tags used by published profile with language 'en'"

    it "shows tags used by published profile with no language"

    it "shows tags used by published profile with language 'de' or 'en'"

    it "shows tags used by a certain profile with no language"

    it "shows tags used by a certain profile with language 'de'" do
      expect(@marie.topics.with_language('de')).to match_array([@tag_one_language_de])
    end

    it "shows tags used by a certain profile with language 'de' and without language" do
      expect(@marie.topics.with_language('de')).to match_array([@tag_one_language_de])
      expect(@marie.topics.without_language).to match_array([@tag_no_language])
      expect(@marie.topics.with_language('de').without_language).to match_array([@tag_one_language_de, @tag_no_language])
    end

    it "shows tags used by a certain profile with language 'en'" do
      expect(@ada.topics.with_language('en')).to match_array([@tag_one_language_en, @tag_both_languages])
    end

    it "shows tags used by a certain profile with language 'de' or 'en'" do
      expect(@ada.topics.with_language(['de', 'en'])).to match_array([@tag_one_language_en, @tag_both_languages])
    end

    it "shows tags with no language" do
      expect(ActsAsTaggableOn::Tag.with_language('')).to match_array([])
    end

    it "shows tags with language 'de'" do
      expect(ActsAsTaggableOn::Tag.with_language('de')).to match_array([@tag_one_language_de, @tag_both_languages])
    end

    it "shows tags with language 'en'" do
      expect(ActsAsTaggableOn::Tag.with_language('en')).to match_array([@tag_one_language_en, @tag_both_languages])
    end

    it "shows tags with language 'de' or 'en'" do
      expect(ActsAsTaggableOn::Tag.with_language(['en','de'])).to match_array([@tag_both_languages, @tag_one_language_en, @tag_one_language_de])
    end
  end

end
