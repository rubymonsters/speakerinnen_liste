describe 'profile', type: :model do
  let(:profile) { FactoryGirl.create(:profile) }

  describe 'profile settings' do
    it "has a valid factory" do
      expect(FactoryGirl.build(:profile)).to be_valid
    end

    it "by default isn't admin" do
      expect(profile.admin).to be(false)
    end

    it 'returns a profile fullname as a string' do
      expect(profile.fullname).to eq "Factory Girl"
    end

    it 'is invalid without email' do
      profile_no_email = FactoryGirl.build(:profile, email: nil)
      profile_no_email.valid?
      expect(profile_no_email.errors[:email].size).to eq(1)
    end

    it "is invalid when email address is already taken" do
      first_profile_same_email = FactoryGirl.create(:profile)
      email = first_profile_same_email.email
      second_profile_same_email = FactoryGirl.build(:profile, email: email)
      second_profile_same_email.valid?
      expect(second_profile_same_email.errors[:email].size).to eq(1)
    end
  end

  describe '#name_or_email' do
    context 'user has no name information only email adress' do
      let(:profile_no_name) { FactoryGirl.create(:profile, firstname: nil, lastname: nil, email: 'factorygirl@test.de') }

      it 'return the email adress' do
        expect(profile_no_name.name_or_email).to eq 'factorygirl@test.de'
      end
    end

    context 'user has name information' do
      it 'return the fullname' do
        expect(profile.name_or_email).to eq 'Factory Girl'
      end
    end

    context 'delete trailing white space' do
      let(:profile) { FactoryGirl.create(:profile, firstname: 'Ada ', lastname: 'Lovelace ', email: 'factorygirl@test.de') }

      it 'in firstname and lastname' do
        expect(profile.firstname).to eq 'Ada'
        expect(profile.lastname).to eq 'Lovelace'
      end
    end
  end

  describe 'iso_languages' do
    it 'is empty' do
      expect(Profile.new.iso_languages).to eq nil
    end

    context 'language string only valid when correct format' do

      it 'is valid for single language' do
        profile = Profile.new(iso_languages: "de")
        profile.valid?
        expect(profile.errors[:iso_languages].size).to eq(0)
      end

      it 'is valid for two languages' do
        profile = Profile.new(iso_languages: "de,en")
        profile.valid?
        expect(profile.errors[:iso_languages].size).to eq(0)
      end

      it 'is valid for three languages' do
        profile = Profile.new(iso_languages: "de,en,fr")
        profile.valid?
        expect(profile.errors[:iso_languages].size).to eq(0)
      end

      it 'is invalid for other strings' do
        profile = Profile.new(iso_languages: "deutsch")
        profile.valid?
        expect(profile.errors[:iso_languages].size).to eq(1)
      end
    end
  end
end
