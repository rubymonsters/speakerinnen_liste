describe 'profile', type: :model do
  describe '.profile_search' do
    let!(:ada) { FactoryGirl.create(:profile, firstname: 'Maren') }

    it 'searches for all profiles by firstname and lastname' do
      expect(Profile.search('Maren').count).to eq 1
    end
  end
end
