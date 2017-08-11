describe TagLanguage, :type => :model do
  let!(:tag) { ActsAsTaggableOn::Tag.create(id: 1, name: 'media') }
  let!(:tag_language) { TagLanguage.create(tag_id: 1, language: 'en') }

  it 'adds a language to the existing tag' do
    expect(tag.tag_languages.first.language).to eq('en')
  end
end
