describe TagLanguage, :type => :model do
  let!(:tag) { ActsAsTaggableOn::Tag.create(id: 1, name: 'social media') }
  let!(:tag_language) { TagLanguage.create(id: 1, tag_id: 1, language: 'en') }
  let!(:tag_language_second) { TagLanguage.create(id: 2, tag_id: 1, language: 'de') }

  it 'adds a language to the existing tag' do
    expect(tag.tag_languages.first.language).to eq('en')
  end

  it 'adds a second language to the existing tag' do
    expect(tag.tag_languages.second.language).to eq('de')
  end

  it 'should only allow available locales as language' do
    record = TagLanguage.new(id: 3, tag_id: 1, language: 'fr')
    record.valid?

    expect(record.errors[:language]).to include("fr is not a valid language")
  end
end
