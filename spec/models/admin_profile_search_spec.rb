describe 'profile', type: :model do
  describe '.profile_search' do
    let!(:inge) { FactoryGirl.create(:profile, firstname: 'Inge') }

    it 'searches for all profiles by firstname and lastname' do
      expect(Profile.search("inge").count).to eq 1
    end

  end
end
