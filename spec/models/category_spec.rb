# frozen_string_literal: true

describe 'category', type: :model do
  let!(:category_sonstiges) { FactoryBot.create(:category, name_en: 'Miscellaneous') }
  let!(:category_A) { FactoryBot.create(:category, name_en: 'Art') }
  let!(:category_B) { FactoryBot.create(:category, name_en: 'Career') }

  describe 'category order' do
    it "orders the english names alphabetically and 'miscellaneous' at the end" do
      categories = Category.sorted_categories
      expect(categories.first.name).to eq 'Art'
      expect(categories.last.name).to eq 'Miscellaneous'
    end
  end
end
