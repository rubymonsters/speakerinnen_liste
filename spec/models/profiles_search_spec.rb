describe ProfilesSearch, type: :model do
  let!(:profile) { FactoryGirl.create(:published, firstname: 'Gertrud', lastname: 'Mueller', twitter: 'Apfel', city: 'Berlin') }

  let!(:profile_language_de) { ProfileLanguage.create!(profile: profile, iso_639_1: 'de') }
  let!(:profile_language_en) { ProfileLanguage.create!(profile: profile, iso_639_1: 'en') }

  let!(:profile_not_matched) { FactoryGirl.create(:published, firstname: 'Claudia', email: 'claudia@test.de', city: 'Paris', twitter: 'Birne') }
  let!(:profile_not_published) { FactoryGirl.create(:unpublished, firstname: 'Fred') }

  let!(:profile_language_de) { ProfileLanguage.create!(profile: profile, iso_639_1: 'de') }
  let!(:profile_language_en) { ProfileLanguage.create!(profile: profile, iso_639_1: 'en') }

  let!(:profile_not_matched) { FactoryGirl.create(:published, firstname: 'Claudia', email: 'claudia@test.de', city: 'Paris', twitter: 'Birne') }
  let!(:profile_not_published) { FactoryGirl.create(:unpublished, firstname: 'Fred') }

  let!(:profile_language_de) { ProfileLanguage.create!(profile: profile, iso_639_1: 'de') }
  let!(:profile_language_en) { ProfileLanguage.create!(profile: profile, iso_639_1: 'en') }

  let!(:profile_not_matched) { FactoryGirl.create(:published, firstname: 'Claudia', email: 'claudia@test.de', city: 'Paris', twitter: 'Birne') }
  let!(:profile_not_published) { FactoryGirl.create(:unpublished, firstname: 'Fred') }

  describe 'results' do

    it 'does not return unpublished profiles' do
      expect(ProfilesSearch.new(quick: 'Fred').results).to be_empty
    end

    context 'quick search' do
      it 'does not return profiles that do not match the given search string' do
        expect(ProfilesSearch.new(quick: 'Horstin').results).to be_empty
      end

      it 'does return profiles that match the lastname' do
        expect(ProfilesSearch.new(quick: 'Muell').results).to eq [profile]
      end

      it 'does return profiles that match the twittername' do
        expect(ProfilesSearch.new(quick: 'apfel').results).to eq [profile]
      end

      it 'does return profiles that match the topic' do
        profile.topic_list.add("obst")
        profile.save!

        expect(ProfilesSearch.new(quick: 'obst').results).to eq [profile]
      end

      it 'does return nothing if only quick is given and empty' do
        expect(ProfilesSearch.new(quick: '').results).to be_empty
      end
    end

    context 'when doing a detailed search' do
      it 'does return profiles that match the given city search string' do
        expect(ProfilesSearch.new({city: 'Berli'}).results).to eq [profile]
      end

      it 'does return profiles that match the given language search string' do
        expect(ProfilesSearch.new({languages: 'en'}).results).to eq [profile]
      end

      it 'does return profiles that match the given name search string' do
        expect(ProfilesSearch.new({name: 'Gertrud'}).results).to eq [profile]
      end

      it 'does return profiles that match the given twitter search string' do
        expect(ProfilesSearch.new({twitter: 'Apf'}).results).to eq [profile]
      end

      it 'does return profiles that match the given topic search string' do
        profile.topic_list.add("obst")
        profile.save!

        expect(ProfilesSearch.new({topics: 'obst'}).results).to eq [profile]
      end

      it 'returns any profile that matches one of the given languages' do
        expect(ProfilesSearch.new({languages: ['en', 'ar']}).results).to eq [profile]
      end

      it 'returns any profile that matches one of the given topics'
    end
  end
end
