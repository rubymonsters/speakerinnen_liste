describe SearchProfilesByCategory do
  let!(:tag_spring) { create(:tag, name: 'spring') }
  let!(:tag_winter) { FactoryBot.create(:tag, name: 'winter') }
  let!(:category_seasons) { create(:category, name: 'Seasons') }
  let!(:category_got) { FactoryBot.create(:category, name: 'Game of Thrones') }

  let(:context) { { category_id: category_seasons.id } }
  let!(:profile) { create(:profile, topic_list: ['spring'], published: true) }

  before do
    tag_spring.categories << category_seasons
    tag_winter.categories << category_got
    create(:profile, topic_list: ['spring'], published: false)
    create(:profile, topic_list: ['winter'], published: true)
  end

  it 'only shows published profiles with the correct category' do
    result = described_class.call(context)
    expect(result.success?).to be true
    expect(result.profiles).to eq([profile])
  end
end
