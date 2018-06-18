# frozen_string_literal: true

class SearchLanguages
  def self.collection_for_dropdown(i18n_language = :en)
    language_array = IsoLanguage.all.map { |language| [language.to_s, I18n.t(language, scope: 'iso_639_1', locale: i18n_language).capitalize] }
    most_used_languages = [['', '----------'], ['en', I18n.t('en', scope: 'iso_639_1').capitalize], ['de', I18n.t('de', scope: 'iso_639_1').capitalize], ['', '----------']]
    most_used_languages + language_array.sort_by { |a| a[1] }
  end
end
