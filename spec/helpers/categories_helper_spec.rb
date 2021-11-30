require "rails_helper"

describe CategoriesHelper, type: :helper do
  let!(:tag_spring) { FactoryBot.create(:tag, name: 'spring') }
  let!(:tag_winter) { FactoryBot.create(:tag, name: 'winter') }

  let!(:category_seasons) { FactoryBot.create(:category, name: 'Seasons') }
  let!(:category_got) { FactoryBot.create(:category, name: 'Game of Thrones') }
  let!(:category_c) { FactoryBot.create(:category, name: 'C') }

  let!(:ada) { FactoryBot.create(:ada, topic_list: ['spring', 'winter']) }
  let!(:marie) { FactoryBot.create(:marie, topic_list: ['spring']) }
  let!(:laura) { FactoryBot.create(:laura, topic_list: ['spring', 'winter']) }
  let!(:paula) { FactoryBot.create(:paula, topic_list: ['spring']) }

  before do
    tag_spring.categories << category_seasons
    tag_winter.categories << category_seasons
    tag_winter.categories << category_got
    tag_spring.save!
    tag_winter.save!
    allow(helper).to receive(:current_region).and_return(current_region)
    Rails.cache.delete('categories_profiles_counts.all')
    Rails.cache.delete("categories_profiles_counts.#{current_region}")
  end

  describe 'on speakerinnen.org' do
    let(:current_region) { nil }

    it "counts the number of profiles per category" do
      expect(helper.category_profiles_count(category_seasons.id)).to eq 4
      expect(helper.category_profiles_count(category_got.id)).to eq 2
      expect(helper.category_profiles_count(category_c.id)).to eq 0
    end

    it "calculates the correct profiles ratios per category" do
      expect(helper.category_profiles_ratio(category_seasons.id)).to eq 100.0
      expect(helper.category_profiles_ratio(category_got.id)).to eq 50.0
    end
  end

  describe 'on vorarlberg.speakerinnen.org' do
    let(:current_region) { 'vorarlberg' }

    it "counts the number of profiles per category" do
      expect(helper.category_profiles_count(category_seasons.id)).to eq 2
      expect(helper.category_profiles_count(category_got.id)).to eq 1
      expect(helper.category_profiles_count(category_c.id)).to eq 0
    end

    it "calculates the correct profiles ratios per category" do
      expect(helper.category_profiles_ratio(category_seasons.id)).to eq 50.0
      expect(helper.category_profiles_ratio(category_got.id)).to eq 25.0
    end
  end
end
