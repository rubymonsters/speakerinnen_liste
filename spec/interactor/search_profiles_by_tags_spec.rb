describe SearchProfilesByTags do
  let(:tags) { %w[algebra algorithm computer] }
  let!(:ada) { create(:profile, topic_list: tags, published: true ) }
  let(:context) { { tags: tags } }

  before do
    create(:profile, topic_list: tags, published: false )
    create(:profile, topic_list: ["other tags"], published: true )
  end

  it 'only shpws published profiles with the correct tags' do
    result = described_class.call(context)
    expect(result.success?).to be true
    expect(result.profiles).to eq([ada])
  end
end
