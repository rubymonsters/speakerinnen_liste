describe LocaleLanguage, type: :model do
  let!(:locale_language) do
    FactoryGirl.create(:locale_language, iso_code: 'de')
  end
  let!(:tag) do
    ActsAsTaggableOn::Tag.create(
      name: 'Physik',
      locale_languages: [locale_language]
    )
  end

  it 'finds associated language of the tag' do
    p locale_language.iso_code
    expect(tag.locale_languages).to match_array([locale_language])
  end

  it 'finds associated tags for a language' do
    expect(locale_language.tags).to match_array([tag])
  end
end
