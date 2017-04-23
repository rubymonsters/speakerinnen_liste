describe 'iso_language', type: :model do

  describe 'lists of language-codes' do
    it "has a list of all language-codes" do
      expect(IsoLanguage.all).to be_an Array
    end

    it 'has a shortlist with most used languages' do
      expect(IsoLanguage.top_list).to include(:en, :fr)
    end

    it 'number of list in top- and rest- equal full list' do
      expect(IsoLanguage.top_list.count + IsoLanguage.rest_list.count).to eq(IsoLanguage.all.count)      
    end
  end

end
