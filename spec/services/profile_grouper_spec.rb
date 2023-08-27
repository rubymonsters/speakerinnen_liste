# frozen_string_literal: true

RSpec.describe ProfileGrouper do
  subject(:agg_hash) { ProfileGrouper.new('de', Profile.pluck(:id)).agg_hash }

  describe "#agg_hash" do
    describe "cities" do
      context "with profiles in different cities" do
        let!(:profile_berlin_1) { FactoryBot.create(:published_profile, city_de: "Berlin") }
        let!(:profile_berlin_2) { FactoryBot.create(:published_profile, city_de: "Berlin") }
        let!(:profile_leipzig) { FactoryBot.create(:published_profile, city_de: "Leipzig") }

        it "returns list of cities ordered by count" do
          expect(
            agg_hash.fetch(:cities).to_a
          ).to eq([["Berlin", 2], ["Leipzig", 1]])
        end
      end

      context "with profiles with translated city names" do
        let!(:profile_berlin) { FactoryBot.create(:published_profile, city_de: "München", city_en: "Munich") }
        let!(:profile_leipzig) { FactoryBot.create(:published_profile, city_de: "Leipzig", city_en: "Leipzig") }

        it "returns a list of cities in German" do
          expect(
            agg_hash.fetch(:cities)
          ).to match_array({"München" => 1, "Leipzig" => 1})
        end

        it "returns a list of cities in English" do
          expect(
            ProfileGrouper.new('en', Profile.pluck(:id)).agg_hash.fetch(:cities)
          ).to match_array({"Munich" => 1, "Leipzig" => 1})
        end
      end

      context "with profiles with city names that contain zip codes" do
        let!(:profile_with_zip) { FactoryBot.create(:published_profile, city_de: "72280 Dornstetten") }

        it "returns a list of cities including the zip code (fix your data)" do
          expect(
            agg_hash.fetch(:cities)
          ).to match_array({"72280 Dornstetten" => 1})
        end
      end

      context "with profiles with two city names in one language" do
        let!(:profile_with_zip) { FactoryBot.create(:published_profile, city_de: "Leipzig und Berlin") }

        it "returns a list of all cities" do
          expect(
            agg_hash.fetch(:cities)
          ).to match_array([["Berlin", 1], ["Leipzig", 1]])
        end
      end
    end

    describe "#languages" do
      context "with profiles with different languages" do
        let!(:profile_english) { FactoryBot.create(:published_profile, iso_languages: ["en"]) }
        let!(:profile_german) { FactoryBot.create(:published_profile, iso_languages: ["de", "en"]) }

        it "returns list of languages ordered by count" do
          expect(
            agg_hash.fetch(:languages)
          ).to eq({"en" => 2, "de" => 1})
        end
      end
    end

    describe "#countries" do
      context "with profiles with different countries" do
        let!(:profile_saxony) { FactoryBot.create(:published_profile, country: "AT") }
        let!(:profile_hamburg) { FactoryBot.create(:published_profile, country: "AT") }
        let!(:profile_austria) { FactoryBot.create(:published_profile, country: "DE") }

        it "returns list of countries ordered by count" do
          expect(
            agg_hash.fetch(:countries).to_a
          ).to eq([["AT", 2], ["DE", 1]])
        end
      end
      context "with profiles with different countries" do
        let!(:profile_saxony) { FactoryBot.create(:published_profile, country: "DE") }
        let!(:profile_hamburg) { FactoryBot.create(:published_profile, country: "AT") }
        let!(:profile_austria) { FactoryBot.create(:published_profile, country: "DE") }

        it "returns list of countries ordered by count" do
          expect(
            agg_hash.fetch(:countries).to_a
          ).to eq([["DE", 2], ["AT", 1]])
        end
      end
    end

    describe "#states" do
      context "with profiles with different states" do
        let!(:profile_saxony) { FactoryBot.create(:published_profile, state: :saxony) }
        let!(:profile_hamburg) { FactoryBot.create(:published_profile, state: :hamburg) }
        let!(:profile_austria) { FactoryBot.create(:published_profile, state: :voralberg) }

        it "returns list of states ordered by count" do
          expect(
            agg_hash.fetch(:states)
          ).to eq({"saxony" => 1, "hamburg" => 1, "voralberg" => 1})
        end
      end
    end
  end
end
