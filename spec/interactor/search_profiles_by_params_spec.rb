describe SearchProfilesByParams do
  let(:params) { { search: 'Handarbeit', filter_city: 'Elend' } }
  let(:context) { { params: params } }
  let!(:profile) { create(:profile, city: 'Elend', published: true, main_topic: "Handarbeit") }

  before do
    create(:profile, main_topic: "Handarbeit", published: false )
    create(:profile, main_topic: "Baumschnitt", published: true )
  end

  it 'only shows published profiles with the correct params' do
    result = described_class.call(context)
    expect(result.success?).to be true
    expect(result.profiles).to eq([profile])
  end

  it 'returns every matching id so the aggregations cover the whole result set' do
    other_city = create(:profile, city: 'Elend', published: true, main_topic: 'Handarbeit')
    result = described_class.call(params: { search: 'Handarbeit' })

    expect(result.profile_ids).to contain_exactly(profile.id, other_city.id)
  end

  it 'leaves pagination to the caller rather than loading every match' do
    result = described_class.call(context)

    expect(result.profiles).to be_a(ActiveRecord::Relation)
    expect(result.profiles.limit(1).size).to eq 1
  end
end
