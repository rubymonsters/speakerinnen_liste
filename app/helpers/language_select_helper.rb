module LanguageSelectHelper
  def language_select
    select_tag(
      "search[languages]",
      options_from_collection_for_select(
        LanguageList::COMMON_LANGUAGES.sort_by { |language| language_name(language) },
        'iso_639_1',
        ->(language) { language_name(language) }
      ),
      include_blank: true,
      multiple: true
    )
  end

  private

  def language_name(language)
    t(language.iso_639_1, scope: 'iso_639_1', default: language.name).capitalize
  end
end

