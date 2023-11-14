# frozen_string_literal: true

describe 'profile', type: :model do
  let!(:profile) { FactoryBot.create(:profile) }
  let!(:profile2) { FactoryBot.create(:ada) }
  let!(:profile3) { FactoryBot.create(:laura) }

  describe 'profile settings' do
    it 'has a valid factory' do
      expect(FactoryBot.build(:profile)).to be_valid
    end

    it "by default isn't admin" do
      expect(profile.admin).to be(false)
    end

    it 'admin is true when user is admin' do
      profile_admin = FactoryBot.build(:profile, admin: true)
      expect(profile_admin.admin).to be(true)
    end

    it 'returns a profile fullname as a string' do
      expect(profile.fullname).to eq 'Susi Sonnenschein'
    end

    it 'is invalid without email' do
      profile_no_email = FactoryBot.build(:profile, email: nil)
      profile_no_email.valid?
      expect(profile_no_email.errors[:email].size).to eq(1)
    end

    it 'is invalid when email address is already taken' do
      first_profile_same_email = FactoryBot.create(:profile)
      email = first_profile_same_email.email
      second_profile_same_email = FactoryBot.build(:profile, email: email)
      second_profile_same_email.valid?
      expect(second_profile_same_email.errors[:email].size).to eq(1)
    end
  end

describe 'admin_search' do
  context 'admin searches for profile by email address' do
    let!(:profile) { create(:profile, email: 'anna.meier@example.org') }

    it 'searches for email address' do
      expect(Profile.admin_search("anna.meier@example.org")).to eq [profile]
    end
  end
end

  describe '#name_or_email' do
    context 'user has no name information only email adress' do
      let(:profile) { create(:profile, firstname: nil, lastname: nil, email: 'factorygirl@test.de') }

      it 'return the email adress' do
        expect(profile.name_or_email).to eq 'factorygirl@test.de'
      end
    end

    context 'user has name information' do
      it 'return the fullname' do
        expect(profile.name_or_email).to eq 'Susi Sonnenschein'
      end
    end

    context 'delete trailing white space' do
      let(:profile) { create(:profile, firstname: 'Ada ', lastname: 'Lovelace ', email: 'factorygirl@test.de') }

      it 'in firstname and lastname' do
        expect(profile.firstname).to eq 'Ada'
        expect(profile.lastname).to eq 'Lovelace'
      end
    end
  end

  describe 'iso_languages' do
    it 'is empty' do
      expect(Profile.new.iso_languages).to eq []
    end

    it 'saves to iso_languages without the empty string in the array' do
      profile = FactoryBot.build(:profile, iso_languages: ['en', 'es', ''])
      profile.save!
      profile.reload
      expect(profile.iso_languages).to eq %w[en es]
    end

    context 'language string only valid when correct format' do
      it 'is valid for single language' do
        profile = Profile.new(iso_languages: ['en'])
        profile.valid?
        expect(profile.errors[:iso_languages].size).to eq(0)
      end

      it 'empty strings are ignored in the validation' do
        # we need them because of empty checkbox array handling Gotcha
        # see: http://api.rubyonrails.org/classes/ActionView/Helpers/FormHelper.html#method-i-check_box
        profile = Profile.new(iso_languages: ['en', ''])
        profile.valid?
        expect(profile.errors[:iso_languages].size).to eq(0)
      end

      it 'is valid for two languages' do
        profile = Profile.new(iso_languages: %w[en de])
        profile.valid?
        expect(profile.errors[:iso_languages].size).to eq(0)
      end
    end
  end

  describe 'profile tag filter' do
    let!(:ruby_expert) { create(:published_profile, topic_list: %w[ruby algorithms]) }
    let!(:java_expert) { create(:published_profile, topic_list: %w[java]) }
    let!(:c_expert) { create(:published_profile, topic_list: %w[c]) }

    it 'only shows the profile which is tagged' do
      expect(Profile.has_tags("ruby").first).to eq ruby_expert
      expect(Profile.has_tags("ruby").count).to eq 1
      expect(Profile.has_tags("ruby, java").count).to eq 2
    end
  end

  describe 'cities' do
    it 'gets rid of additional charaters' do
      profile.city_de = 'Rom & Wien'
      profile.city_en = 'Rom or Paris'
      profile.save!
      expect(profile.cities).to eq(%w[Rom Wien Paris])
    end
  end

  describe 'profession' do
    it 'returns a profession' do
      expect(profile2.profession).to eq("computer scientist")
    end

    it 'forces 80 character limit for a profession' do
      profile = Profile.new(profession: 'a' * 61)
      profile.valid?
      expect(profile.errors[:profession].size).to eq(1)
    end
  end

  describe 'by_region' do
    before do
      create(:published_profile, country: 'AT', state: 'vorarlberg')
      create(:published_profile, country: 'AT', state: 'vorarlberg')
      create(:published_profile, country: 'AT', state: 'upper-austria')
      create(:published_profile, country: 'DE', state: 'berlin')
      create(:published_profile, state: nil)
    end

    it { expect(Profile.by_region('AT').count).to eq 5 }
    it { expect(Profile.by_region('DE').count).to eq 1 }
    it { expect(Profile.by_region(:'vorarlberg').count).to eq 3 }
    it { expect(Profile.by_region(:ooe).count).to eq 1 }
    it { expect(Profile.by_region('berlin').count).to eq 1 }
    it { expect(Profile.by_region('hamburg').count).to eq 0 }
    it { expect(Profile.by_region(nil).count).to eq 8 }
  end

  describe 'search' do
    it 'returns a profile by firstname' do
      expect(Profile.search('Ada').count).to eq 1
    end

    it 'returns a profile by lastname' do
      expect(Profile.search('Lovelace').count).to eq 1
    end

    it 'returns a profile by fullname' do
      expect(Profile.search('Ada Lovelace').count).to eq 1
    end

    it 'returns a profile by twitter_de handle' do
      expect(Profile.search('alovelace_de').count).to eq 1
    end

    it 'returns a profile by twitter_en handle' do
      expect(Profile.search('alovelace_en').count).to eq 1
    end

    it 'returns a profile by bio_de' do
      expect(Profile.search('Algorithmus').count).to eq 1
    end

    it 'returns a profile by bio_en' do
      expect(Profile.search('algorithm').count).to eq 1
    end

    it 'returns a profile by main_topic_de' do
      expect(Profile.search('Mathematik Genie').count).to eq 1
    end

    it 'returns a profile by main_topic_en' do
      expect(Profile.search('math wiz').count).to eq 1
    end

    it 'returns a profile by city_en' do
      expect(Profile.search('London').count).to eq 1
    end

    it 'returns a profile by state' do
      expect(Profile.search('carinthia').count).to eq 1
    end

    it 'returns partial matches of a word' do
      expect(Profile.search('Love').count).to eq 1
    end
  end
end
