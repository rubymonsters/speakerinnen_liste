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
end
