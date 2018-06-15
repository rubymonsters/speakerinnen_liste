# frozen_string_literal: true

describe 'iso_language' do
  describe 'lists of language-codes' do
    it 'has a list of all language-codes as two letter strings' do
      expect(IsoLanguage.all).to be_an Array
      expect(IsoLanguage.all.map(&:class).uniq).to eq [String]
    end

    it 'has a shortlist with most used languages' do
      expect(IsoLanguage.top_list).to include('en', 'fr')
    end

    it 'number of list in top- and rest- equal full list' do
      expect(IsoLanguage.top_list.count + IsoLanguage.rest_list.count).to eq(IsoLanguage.all.count)
    end

    it 'has an array of arrays with languagenames and iso characters' do
      expect(IsoLanguage.all_languagenames_with_iso).to be_an Array
      expect(IsoLanguage.all_languagenames_with_iso.flatten).to include('Englisch', 'en')
    end
  end
end
