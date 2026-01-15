RSpec.describe Profiles::IndexInteractor do
  let(:region) { nil }
  let(:params) { {} }

  subject(:result) { described_class.call(params: params, region: region) }

  context 'when there are profiles' do
    let!(:profile) { create(:profile, :published) }

    it 'succeeds and returns paginated records' do
      expect(result).to be_success
      expect(result.records).to include(profile)
    end
  end

  context 'when tag_filter is empty' do
    let(:params) { { tag_filter: [] } }

    it 'fails with proper message' do
      expect(result).not_to be_success
      expect(result.message).to eq(I18n.t('flash.profiles.no_tags_selected'))
    end
  end
end
