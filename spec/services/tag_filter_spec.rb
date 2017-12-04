describe TagFilter do
  subject(:tag_filter) { described_class.new(ActsAsTaggableOn::Tag.all, filter_params).filter }

  let!(:locale_language_en) do
    FactoryGirl.create(:locale_language, iso_code: 'en')
  end
  let!(:locale_language_de) do
    FactoryGirl.create(:locale_language, iso_code: 'de')
  end

  let!(:tag_en_de) do
    ActsAsTaggableOn::Tag.create!(
      name: 'social media',
      locale_languages: [locale_language_en, locale_language_de]
    )
  end
  let!(:tag_no_lang) { ActsAsTaggableOn::Tag.create!(name: 'ruby') }
  let!(:tag_en) do
    ActsAsTaggableOn::Tag.create!(
      name: 'entertainment',
      locale_languages: [locale_language_en]
    )
  end
  let!(:tag_de) do
    ActsAsTaggableOn::Tag.create!(
      name: 'Soziale Medien',
      locale_languages: [locale_language_de]
    )
  end

  let!(:category_1) { Category.create!(id: 1, name: 'marketing & pr', tags: [tag_en_de, tag_de]) }
  let!(:category_2) { Category.create!(id: 2, name: 'development', tags: [tag_no_lang]) }

  context 'with empty filter params' do
    let(:filter_params) { {} }
    it { is_expected.to match_array([tag_en_de, tag_no_lang, tag_en, tag_de]) }
  end

  context 'with given but empty categories' do
    let(:filter_params) { { uncategorized: true } }
    it { is_expected.to match_array([tag_en]) }
  end

  context 'with a given category' do
    let(:filter_params) { { category_id: 1 } }
    it { is_expected.to match_array([tag_en_de, tag_de]) }
  end

  context 'with a given query' do
    let(:filter_params) { { q: 'ruby' } }
    it { is_expected.to match_array([tag_no_lang]) }
  end

  context 'with empty category and given query' do
    let(:filter_params) { { uncategorized: true, q: 'entertainment' } }
    it { is_expected.to match_array([tag_en]) }
  end

  context 'with given but empty language params' do
    let(:filter_params) { { no_language: true } }
    it { is_expected.to match_array([tag_no_lang]) }
  end

  context 'with given language params' do
    let(:filter_params) { { filter_languages: ['en'] } }
    it { is_expected.to match_array([tag_en_de, tag_en]) }
  end

  context 'with two given language params' do
    let(:filter_params) { { filter_languages: ['de', 'en'] } }
    it { is_expected.to match_array([tag_en_de]) }
  end

  context 'with given category and language params' do
    let(:filter_params) { { category_id: 1, filter_languages: ['en'] } }
    it { is_expected.to match_array([tag_en_de]) }
  end

  context 'with given category and empty language params' do
    let(:filter_params) { { category_id: 2, no_language: true } }
    it { is_expected.to match_array([tag_no_lang]) }
  end
end
