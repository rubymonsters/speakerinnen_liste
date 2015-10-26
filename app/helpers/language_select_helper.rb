module LanguageSelectHelper
  def language_select(name)
    select_tag(
      name,
      options_from_collection_for_select(
         SelectableLanguages.to_a.sort_by { |language| language_name(language) },
        'iso_639_1',
        ->(language) { language_name(language) }
      ),
      include_blank: true
    )
  end

  private

  def language_name(language)
    t(language.iso_639_1, scope: 'iso_639_1', default: language.name).capitalize
  end
end

