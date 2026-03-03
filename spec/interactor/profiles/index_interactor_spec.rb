RSpec.describe Profiles::IndexInteractor do
  let(:region) { nil }
  let(:params) { {} }

  subject(:result) { described_class.call(params: params, region: region) }

  context 'when there are profiles' do
    let!(:profile) { create(:published_profile) }

    it 'succeeds and returns paginated records' do
      expect(result).to be_success
      expect(result.records).to include(profile)
    end
  end
end
