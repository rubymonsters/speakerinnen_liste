describe CategoriesProfilesStats do
  let!(:tag_spring) { create(:tag, name: 'spring') }
  let!(:tag_winter) { create(:tag, name: 'winter') }

  let!(:category_seasons) { create(:category, name: 'Seasons') }
  let!(:category_got) { create(:category, name: 'Game of Thrones') }
  let!(:category_c) { create(:category, name: 'C') }

  let!(:ada) { create(:ada, topic_list: %w[spring winter]) }
  let!(:marie) { create(:marie, topic_list: ['spring']) }
  let!(:laura) { create(:laura, topic_list: %w[spring winter]) }
  let!(:paula) { create(:paula, topic_list: ['spring']) }

  before do
    tag_spring.categories << category_seasons
    tag_winter.categories << category_seasons
    tag_winter.categories << category_got
    tag_spring.save!
    tag_winter.save!
    Rails.cache.delete('categories_profiles_counts.all')
    Rails.cache.delete("categories_profiles_counts.#{current_region}")
  end

  describe 'on speakerinnen.org' do
    let(:current_region) { nil }

    it 'calculates the correct number of published profiles per category' do
      result = CategoriesProfilesStats.call(region: current_region)
      # byebug
      expect(result.categories_profiles_counts[category_seasons.id]).to eq 4
      expect(result.categories_profiles_counts[category_got.id]).to eq 2
      expect(result.categories_profiles_counts[category_c.id]).to be_nil
    end

    it 'calculates the correct total number of published profiles' do
      ada.update(published: false)
      result = CategoriesProfilesStats.call(region: current_region)
      expect(result.profiles_count).to eq 3
    end
  end

  describe 'on vorarlberg.speakerinnen.org' do
    let(:current_region) { 'vorarlberg' }
    before do
      ada.update(state: 'vorarlberg')
      marie.update(state: 'vorarlberg')
      laura.update(state: 'salzburg')
    end
    it 'calculates the correct number of published profiles per category' do
      result = CategoriesProfilesStats.call(region: current_region)
      expect(result.categories_profiles_counts[category_seasons.id]).to eq 3
      expect(result.categories_profiles_counts[category_got.id]).to eq 1
      expect(result.categories_profiles_counts[category_c.id]).to be_nil
    end

    it 'calculates the correct total number of published profiles' do
      marie.update(published: false)
      result = CategoriesProfilesStats.call(region: current_region)
      expect(result.profiles_count).to eq 2
    end
  end

  describe 'on upper-austria.speakerinnen.org' do
    let(:current_region) { :ooe }
    before do
      ada.update(state: 'upper-austria')
      marie.update(state: 'upper-austria')
      laura.update(state: 'salzburg')
    end
    it 'calculates the correct number of published profiles per category' do
      result = CategoriesProfilesStats.call(region: current_region)
      expect(result.categories_profiles_counts[category_seasons.id]).to eq 2
      expect(result.categories_profiles_counts[category_got.id]).to eq 1
      expect(result.categories_profiles_counts[category_c.id]).to be_nil
    end

    it 'calculates the correct total number of published profiles' do
      marie.update(published: false)
      result = CategoriesProfilesStats.call(region: current_region)
      expect(result.profiles_count).to eq 1
    end
  end
end
