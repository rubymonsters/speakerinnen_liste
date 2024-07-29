describe GetAllProfiles do
  let(:context) { {} }
  let!(:profile) { create(:profile, published: true, main_topic_de: 'math') }

  before do
    create(:profile, published: false)
  end

  it 'only shows published profiles' do
    result = described_class.call(context)
    expect(result.success?).to be true
    expect(result.profiles).to eq([profile])
  end
end
