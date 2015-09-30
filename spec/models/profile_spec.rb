describe 'profile', type: :model do
  let(:profile) { FactoryGirl.create(:profile) }

  describe 'profile settings' do
    it 'has a valid factory' do
     expect(FactoryGirl.build(:profile)).to be_valid
     end

    it "by default isn't admin" do
      expect(profile.admin).to be(false)
    end

    it 'returns a profile fullname as a string' do
      expect(profile.fullname).to eq 'Factory Girl'
    end
  end

  describe '#name_or_email' do
    context 'user has no name information' do
      let(:profile_no_name) { FactoryGirl.create(:profile, firstname: nil, lastname: nil) }

      it 'return the email adress' do
        expect(profile_no_name.name_or_email).to eq 'factorygirl@test.de'
      end
    end

    context 'user has name information' do
      it 'return the fullname' do
        expect(profile.name_or_email).to eq 'Factory Girl'
      end
    end
  end
end
