# frozen_string_literal: true

describe LocaleLanguage, type: :model do
  let!(:locale_language_de) { create(:locale_language, :de) }
  let!(:locale_language_en) { create(:locale_language, :en) }

  let!(:tag_de) { create(:tag_chemie, locale_languages: [locale_language_de]) }
  let!(:tag_en) { create(:tag_physics, locale_languages: [locale_language_en]) }
  let!(:tag_no_language) { create(:tag, name: 'mathematic') }
  let!(:tag_with_unpublished_profile) { create(:tag, name: 'sports') }
  let!(:tag_both_languages) do
    create(:tag_social_media,
           locale_languages: [locale_language_en, locale_language_de])
  end

  let!(:cat_1) { create(:cat_science, id: 1, tags: [tag_de, tag_en]) }
  let!(:cat_2) { create(:cat_social, id: 2) }

  let!(:ada) { create(:ada, topic_list: [tag_en, tag_both_languages]) }
  let!(:marie) { create(:marie, topic_list: [tag_de, tag_no_language]) }
  let!(:susi) { create(:unpublished_profile, topic_list: [tag_de, tag_with_unpublished_profile]) }

  it 'finds associated language of the tag' do
    expect(tag_de.locale_languages).to match_array([locale_language_de])
  end

  it 'finds associated tags for a language' do
    expect(locale_language_de.tags).to match_array([tag_de, tag_both_languages])
  end

  it 'adds a language to the existing tag' do
    expect(tag_de.locale_languages.first.iso_code).to eq('de')
  end

  describe 'show all tags' do
    it 'only for published profiles' do
      expect(ActsAsTaggableOn::Tag.with_published_profile)
        .to match_array([tag_de, tag_en, tag_both_languages, tag_no_language])
    end

    it 'that belong to a certain category' do
      expect(ActsAsTaggableOn::Tag.belongs_to_category(1))
        .to match_array([tag_de, tag_en])
    end

    it 'only for published profile that belong to a certain category' do
      expect(ActsAsTaggableOn::Tag.belongs_to_category(1)
        .with_published_profile)
        .to match_array([tag_de, tag_en])
    end

    # in a language sope show all tags belonging to that language
    # tags with no languages attached are not shown
    describe 'in language scope' do
      it "'de' and only published profile" do
        expect(ActsAsTaggableOn::Tag.with_published_profile
          .with_language('de'))
          .to match_array([tag_de, tag_both_languages])
      end

      it "'en' and only published profile" do
        expect(ActsAsTaggableOn::Tag.with_published_profile
          .with_language('en'))
          .to match_array([tag_en, tag_both_languages])
      end

      it "'de' and only published profile that belong to a certain category" do
        expect(ActsAsTaggableOn::Tag.belongs_to_category(1)
          .with_published_profile
          .with_language('de'))
          .to match_array([tag_de])
      end

      it "'en' and only published profile that belong to a certain category" do
        expect(ActsAsTaggableOn::Tag.belongs_to_category(1)
          .with_published_profile
          .with_language('en'))
          .to match_array([tag_en])
      end

      it 'no language' do
        expect(ActsAsTaggableOn::Tag.with_language('')).to match_array([])
      end

      it 'de' do
        expect(ActsAsTaggableOn::Tag.with_language('de')).to match_array([tag_de, tag_both_languages])
      end

      it 'en' do
        expect(ActsAsTaggableOn::Tag.with_language('en')).to match_array([tag_en, tag_both_languages])
      end

      # does that make sense? Can the language sope be de AND en?
      it 'de or en' do
        expect(ActsAsTaggableOn::Tag.with_language(%w[en de])).to match_array([tag_both_languages, tag_en, tag_de])
      end
    end
  end

  describe 'shows no tags in a language scope' do
    it 'when the category has no published profile' do
      expect(ActsAsTaggableOn::Tag.belongs_to_category(2)
        .with_published_profile).to be_empty
    end
  end

  describe 'show all tags for a certain profile' do
    it 'with no language scope' do
      expect(marie.topics).to match_array([tag_de, tag_no_language])
    end

    describe 'in language scope' do
      it "'de'" do
        expect(marie.topics.with_language('de')).to match_array([tag_de])
      end

      it "'en'" do
        expect(ada.topics.with_language('en')).to match_array([tag_en, tag_both_languages])
      end

      it "'de' and without a language" do
        expect(marie.topics.with_language('de')).to match_array([tag_de])
        expect(marie.topics.without_language).to match_array([tag_no_language])
        topics_in_correct_language_and_without_any = []
        topics_in_correct_language_and_without_any << marie.topics.with_language('de')
        topics_in_correct_language_and_without_any << marie.topics.without_language
        expect(topics_in_correct_language_and_without_any.flatten.uniq).to match_array([tag_de, tag_no_language])
      end

      it "'en' and 'de'" do
        expect(ada.topics.with_language(%w[de en])).to match_array([tag_en, tag_both_languages])
      end
    end
  end
end
