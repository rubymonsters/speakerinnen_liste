# frozen_string_literal: true

describe 'category', type: :model do
  let!(:category_sonstiges) { FactoryBot.create(:category, name_en: 'Miscellaneous', position:2) }
  let!(:category_A) { FactoryBot.create(:category, name_en: 'Art', position: 3) }
  let!(:category_B) { FactoryBot.create(:category, name_en: 'Career', position: 1) }

  describe 'category order' do
    it "orders via the position field" do
      categories = Category.sorted_categories
      expect(categories.first.name).to eq 'Career'
      expect(categories.last.name).to eq 'Art'
    end
  end
end
