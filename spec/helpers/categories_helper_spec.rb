require 'rails_helper'

RSpec.describe CategoriesHelper, type: :helper do
  let(:category) { double(id: 1, name: 'Food') }

  before do
    # stub Rails URL helpers
    allow(helper).to receive(:category_path).and_return('/categories/1')
    allow(helper).to receive(:link_to) { |name, path, options| "#{name} -> #{path}" }
  end

  describe '#category_link' do
    it 'creates a link without anchor' do
      result = helper.category_link(category)

      expect(result).to eq('Food -> /categories/1')
      expect(helper).to have_received(:category_path).with(category.id)
    end

    it 'creates a link with anchor' do
      allow(helper).to receive(:category_path).and_return('/categories/1#section')

      result = helper.category_link(category, 'section')

      expect(result).to eq('Food -> /categories/1#section')
      expect(helper).to have_received(:category_path).with(category.id, anchor: 'section')
    end
  end

  describe '#category_profiles_count' do
    before do
      helper.instance_variable_set(:@categories_profiles_counts, { 1 => 7 })
    end

    it 'returns the count for a category' do
      expect(helper.category_profiles_count(1)).to eq(7)
    end

    it 'returns 0 if category is missing' do
      expect(helper.category_profiles_count(999)).to eq(0)
    end
  end

  describe '#category_profiles_ratio' do
    before do
      helper.instance_variable_set(:@categories_profiles_counts, { 1 => 25 })
      helper.instance_variable_set(:@profiles_count, 100)
    end

    it 'calculates the correct ratio' do
      expect(helper.category_profiles_ratio(1)).to eq(25.0)
    end

    it 'returns 0 when profiles_count is zero' do
      helper.instance_variable_set(:@profiles_count, 0)

      expect(helper.category_profiles_ratio(1)).to eq(0)
    end
  end

  describe '#category_bar_widths' do
    before do
      helper.instance_variable_set(:@categories_profiles_counts, { 1 => 25 })
      helper.instance_variable_set(:@profiles_count, 100)
    end

    it 'returns correct bar widths' do
      # ratio = 25%
      # bar_1 = 40 + 25 = 65
      # bar_2 = 200 - 65 = 135

      expect(helper.category_bar_widths(1)).to eq([65.0, 135.0])
    end
  end
end
