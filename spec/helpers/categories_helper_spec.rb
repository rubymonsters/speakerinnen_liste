require "rails_helper"

describe CategoriesHelper, type: :helper do
  let!(:tag_spring) { FactoryBot.create(:tag, name: 'spring') }
  let!(:tag_winter) { FactoryBot.create(:tag, name: 'winter') }

  let!(:category_Seasons) { FactoryBot.create(:category, name: 'Seasons') }
  let!(:category_GOT) { FactoryBot.create(:category, name: 'Game of Thrones') }
  let!(:category_C) { FactoryBot.create(:category, name: 'C') }

  let!(:ada) { FactoryBot.create(:ada, firstname: 'Ada', topic_list: ['spring', 'winter']) }
  let!(:marie) { FactoryBot.create(:marie, firstname: 'Marie', topic_list: ['spring']) }

  before do
    tag_spring.categories << category_Seasons
    tag_winter.categories << category_Seasons
    tag_winter.categories << category_GOT
    tag_spring.save!
    tag_winter.save!
    Rails.cache.delete('categories_profiles_counts')
  end

  it "counts the number profiles per category" do
    profiles_count_1 = helper.category_profiles_count(category_Seasons.id)
    profiles_count_2 = helper.category_profiles_count(category_GOT.id)
    profiles_count_3 = helper.category_profiles_count(category_C.id)

    expect(profiles_count_1).to eq 2
    expect(profiles_count_2).to eq 1
    expect(profiles_count_3).to eq 0
  end

  it "calculates the correct profiles ratios per category" do
    profiles_ratio_1 = helper.category_profiles_ratio(category_Seasons.id)
    profiles_ratio_2 = helper.category_profiles_ratio(category_GOT.id)

    expect(profiles_ratio_1).to eq 100.0
    expect(profiles_ratio_2).to eq 50.0
  end
end
