# frozen_string_literal: true

describe CategoriesProfilesStats do
  let(:current_region) { nil }

  let(:en_locale) { create(:locale_language, :en) }
  let(:de_locale) { create(:locale_language, :de) }

  let!(:tag_spring) { create(:tag_spring, locales: [en_locale]) }
  let!(:tag_winter) { create(:tag_winter, locales: [en_locale, de_locale]) }
  let!(:tag_summer) { create(:tag_summer, locales: []) }

  let!(:category_seasons) { create(:category, name: 'Seasons') }
  let!(:category_got) { create(:category, name: 'Game of Thrones') }

  let!(:ada) { create(:published_profile, topic_list: %w[spring winter]) }
  let!(:marie) { create(:published_profile, topic_list: ['spring']) }
  let!(:sophia) { create(:published_profile, topic_list: ['summer']) }
  before do
    tag_spring.categories << category_seasons
    tag_winter.categories << category_seasons
    tag_summer.categories << category_seasons
    tag_winter.categories << category_got
    tag_spring.save!
    tag_winter.save!
    tag_summer.save!
    Rails.cache.clear
  end

  context 'in locale de with no region' do
    it 'one profile has an german tag ( winter_tag )' do
      I18n.locale = :de
      result = CategoriesProfilesStats.call(region: current_region)

      expect(result.categories_profiles_counts[category_seasons.id]).to eq 2
      expect(result.categories_profiles_counts[category_got.id]).to eq 1
      expect(result.profiles_count).to eq 2
    end
  end
  context 'in locale en with no region' do
    it 'shows profiles with english and non language tags' do
      I18n.locale = :en
      result = CategoriesProfilesStats.call(region: current_region)
      expect(result.categories_profiles_counts[category_seasons.id]).to eq 3
      expect(result.categories_profiles_counts[category_got.id]).to eq 1
      expect(result.profiles_count).to eq 3
    end
  end

  context 'with regions and locale :de' do
    let!(:category_c) { create(:category, name: 'C') }

    let!(:laura) { create(:published_profile, topic_list: %w[spring winter]) }
    let!(:paula) { create(:published_profile, topic_list: %w[spring winter]) }
    describe 'on speakerinnen.org' do
      let(:current_region) { nil }

      it 'calculates the correct number of published profiles per category' do
        # laura and ada have german tags so are counted
        result = CategoriesProfilesStats.call(region: current_region)
        expect(result.categories_profiles_counts[category_seasons.id]).to eq 4
        expect(result.categories_profiles_counts[category_got.id]).to eq 3
        expect(result.categories_profiles_counts[category_c.id]).to be_nil
        expect(result.profiles_count).to eq 4
      end

      it 'calculates the correct total number of published profiles' do
        # laura and ada have german tags so are counted
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
        paula.update(state: 'vorarlberg')
        laura.update(state: 'salzburg')
      end
      it 'calculates the correct number of published profiles per category' do
        # laura is in salzburg so not counted even though she has german tags
        # ada is in vorarlberg and has a german tag so is counted
        # both are in the category seasons and category got
        result = CategoriesProfilesStats.call(region: current_region)
        expect(result.categories_profiles_counts[category_seasons.id]).to eq 2
        expect(result.categories_profiles_counts[category_got.id]).to eq 2
        expect(result.categories_profiles_counts[category_c.id]).to be_nil
        expect(result.profiles_count).to eq 2
      end

      it 'calculates the correct total number of published profiles' do
        ada.update(published: false)
        result = CategoriesProfilesStats.call(region: current_region)
        expect(result.profiles_count).to eq 1
      end
    end

    describe 'on ooe.speakerinnen.org' do
      let(:current_region) { :ooe }
      before do
        ada.update(state: 'upper-austria')
        marie.update(state: 'upper-austria')
        paula.update(state: 'upper-austria')
        laura.update(state: 'salzburg')
      end
      it 'calculates the correct number of published profiles per category' do
        result = CategoriesProfilesStats.call(region: current_region)
        expect(result.categories_profiles_counts[category_seasons.id]).to eq 2
        expect(result.categories_profiles_counts[category_got.id]).to eq 2
        expect(result.categories_profiles_counts[category_c.id]).to be_nil
        expect(result.profiles_count).to eq 2
      end

      it 'calculates the correct total number of published profiles' do
        ada.update(published: false)
        result = CategoriesProfilesStats.call(region: current_region)
        expect(result.profiles_count).to eq 1
      end
    end
  end
end
