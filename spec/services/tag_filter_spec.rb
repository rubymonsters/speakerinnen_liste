# frozen_string_literal: true

describe TagFilter do
  subject(:tag_filter) { described_class.new(ActsAsTaggableOn::Tag.all, filter_params).filter }

  let!(:locale_language_de) { FactoryBot.create(:locale_language, :de) }
  let!(:locale_language_en) { FactoryBot.create(:locale_language, :en) }

  let!(:tag_de) { FactoryBot.create(:tag_chemie, locale_languages: [locale_language_de]) }
  let!(:tag_en) { FactoryBot.create(:tag_physics, locale_languages: [locale_language_en]) }
  let!(:tag_no_lang) { FactoryBot.create(:tag, name: 'ruby') }
  let!(:tag_en_de) do
    FactoryBot.create(:tag_social_media,
                      locale_languages: [locale_language_en, locale_language_de])
  end
  let!(:tag_no_lang) { ActsAsTaggableOn::Tag.create!(name: 'ruby') }

  let!(:cat_1) { FactoryBot.create(:cat_science, id: 1, tags: [tag_de, tag_en_de]) }
  let!(:cat_2) { FactoryBot.create(:cat_social, id: 2, tags: [tag_no_lang]) }

  context 'with empty filter params' do
    let(:filter_params) { {} }
    it { is_expected.to match_array([tag_en_de, tag_no_lang, tag_en, tag_de]) }
  end

  context 'with given but empty categories' do
    let(:filter_params) { { category_id: 'uncategorized' } }
    it { is_expected.to match_array([tag_en]) }
  end

  context 'with given all categoriies' do
    let(:filter_params) { { category_id: 'categorized' } }
    it { is_expected.to match_array([tag_en_de, tag_no_lang, tag_de]) }
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
    let(:filter_params) { { category_id: 'uncategorized', q: 'physics' } }
    it { is_expected.to match_array([tag_en]) }
  end

  context 'with all categories and given query' do
    let(:filter_params) { { category_id: 'categorized', q: 'chemie' } }
    it { is_expected.to match_array([tag_de]) }
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
    let(:filter_params) { { filter_languages: %w[de en] } }
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
