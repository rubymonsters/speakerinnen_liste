# frozen_string_literal: true

describe Search do
  let!(:profile) { FactoryBot.create(:profile) }
  let!(:profile2) { FactoryBot.create(:ada) }
  let!(:profile3) { FactoryBot.create(:laura) }

  it 'returns a profile by firstname' do
    expect(described_class.new('Ada').profiles.count).to eq 1
  end

  it 'returns a profile by lastname' do
    expect(described_class.new('Lovelace').profiles.count).to eq 1
  end

  it 'returns a profile by fullname' do
    expect(described_class.new('Ada Lovelace').profiles.count).to eq 1
  end

  it 'returns a profile by twitter_de handle' do
    expect(described_class.new('alovelace_de').profiles.count).to eq 1
  end

  it 'returns a profile by twitter_en handle' do
    expect(described_class.new('alovelace_en').profiles.count).to eq 1
  end

  it 'returns a profile by bio_de' do
    expect(described_class.new('Algorithmus').profiles.count).to eq 1
  end

  it 'returns a profile by bio_en' do
    expect(described_class.new('algorithm').profiles.count).to eq 1
  end

  it 'returns a profile by main_topic_de' do
    expect(described_class.new('Mathematik Genie').profiles.count).to eq 1
  end

  it 'returns a profile by main_topic_en' do
    expect(described_class.new('math wiz').profiles.count).to eq 1
  end

  it 'returns a profile by city_en' do
    expect(described_class.new('London').profiles.count).to eq 1
  end

  it 'returns a profile by state' do
    expect(described_class.new('carinthia').profiles.count).to eq 1
  end

  it 'returns partial matches of a word' do
    expect(described_class.new('Love').profiles.count).to eq 1
  end

  xit 'returns a profile by its topics' do
    profile.topic_list = ['Ruby', 'Rails']
    profile.save
    profile.reload

    expect(described_class.new('ruby').profiles.count).to eq 1
  end

  context 'facets' do
    let!(:french_profile) do
      create(
        :ada,
        iso_languages: ['fr'],
        country: 'DE',
        city: 'Berlin',
        state: 'Berlin'
      )
    end

    before do
      @aggs = described_class.new('Ada').aggregations_hash
    end

    it 'scopes the search results by language' do
      expect(@aggs[:languages].fetch('fr')).to eq 1
    end

    it 'scopes the search results by country' do
      expect(@aggs[:countries].fetch('DE')).to eq 1
    end

    it 'scopes the search results by city' do
      expect(@aggs[:cities].fetch('Berlin')).to eq 1
    end

    it 'scopes the search results by state' do
      expect(@aggs[:states].fetch('Berlin')).to eq 1
    end
  end
end
