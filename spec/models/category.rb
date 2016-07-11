describe 'category', type: :model do

  let!(:category_sonstiges) { FactoryGirl.create(:category, name: 'Sonstiges') }
  let!(:category_A) { FactoryGirl.create(:category, name: 'A') }
  let!(:category_B) { FactoryGirl.create(:category, name: 'B') }

  describe 'category order' do
    it "orders alphabetically and 'Sonstiges' at the end" do
      @categories = Category.sorted_categories

      expect(@categories.first.name).to eq 'A'
      expect(@categories.last.name).to eq 'Sonstiges'
    end
  end

end

