describe TagFilter do
  subject(:tag_filter) { described_class.new(ActsAsTaggableOn::Tag.all, filter_params).filter }

  let!(:tag_1) { ActsAsTaggableOn::Tag.create!(id: 1, name: 'social media') }
  let!(:tag_2) { ActsAsTaggableOn::Tag.create!(id: 2, name: 'ruby') }
  let!(:category_1) { Category.create!(id: 1, name: 'marketing & pr', tags: [tag_1]) }

  let!(:tag_language) { TagLanguage.create!(id: 1, tag_id: 1, language: 'en') }
  let!(:tag_language_second) { TagLanguage.create!(id: 2, tag_id: 1, language: 'de') }

  context 'with empty filter params' do
    let(:filter_params) { {} }
    it  { is_expected.to match_array([tag_1, tag_2]) }
  end

  context 'with given but empty categories' do
    let(:filter_params) { { uncategorized: nil } }
    it  { is_expected.to match_array([tag_1, tag_2]) }
  end

  context 'with a given category' do
    let(:filter_params) { { category_id: 1 } }
    it  { is_expected.to match_array([tag_1]) }
  end
end
