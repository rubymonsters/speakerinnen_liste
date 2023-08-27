# frozen_string_literal: true

RSpec.describe ProfileGrouper do
  describe "#grouped_cities" do
    context "with profiles in different cities" do
      let!(:profile_berlin) { FactoryBot.create(:published_profile, city_de: "Berlin") }
      let!(:profile_leipzig) { FactoryBot.create(:published_profile, city_de: "Leipzig") }

      it "returns a list of cities" do
        expect(
          ProfileGrouper.new('de', [profile_leipzig.id, profile_berlin.id]).grouped_cities
        ).to match_array([["Berlin", 1], ["Leipzig", 1]])
      end
    end

    context "with profiles with translated city names" do
      let!(:profile_berlin) { FactoryBot.create(:published_profile, city_de: "München", city_en: "Munich") }
      let!(:profile_leipzig) { FactoryBot.create(:published_profile, city_de: "Leipzig", city_en: "Leipzig") }

      it "returns a list of cities in German" do
        expect(
          ProfileGrouper.new('de', [profile_leipzig.id, profile_berlin.id]).grouped_cities
        ).to match_array([["München", 1], ["Leipzig", 1]])
      end

      it "returns a list of cities in English" do
        expect(
          ProfileGrouper.new('en', [profile_leipzig.id, profile_berlin.id]).grouped_cities
        ).to match_array([["Munich", 1], ["Leipzig", 1]])
      end
    end

    context "with profiles with city names that contain zip codes" do
      let!(:profile_with_zip) { FactoryBot.create(:published_profile, city_de: "72280 Dornstetten") }

      it "returns a list of santized cities" do
        expect(
          ProfileGrouper.new('de', [profile_with_zip.id]).grouped_cities
        ).to match_array([["Dornstetten", 1]])
      end
    end
  end
end
