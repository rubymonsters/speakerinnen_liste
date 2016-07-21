# Encoding: utf-8

class SearchLanguages
  @languages = {  af: 'afrikaans',
                  ar: 'arabic',
                  be: 'belarusian',
                  bg: 'bulgrian',
                  ca: 'català',
                  ce: 'čečenský',
                  da: 'danske',
                  de: 'deutsch',
                  el: 'greek',
                  en: 'english',
                  es: 'español',
                  fa: 'persian',
                  fi: 'suomi',
                  fr: 'français',
                  he: 'hebrew',
                  hi: 'hindi',
                  hr: 'hrvatska',
                  hu: 'magyar',
                  is: 'icelandic',
                  it: 'italiano',
                  ku: 'kurdish',
                  nl: 'nederlands',
                  no: 'norsk',
                  pl: 'polskie',
                  pt: 'português',
                  ro: 'română',
                  ru: 'russian',
                  sk: 'slovenský',
                  sl: 'slovenskih',
                  sr: 'srpski',
                  sv: 'svensk',
                  uk: 'ukrainian',
                  zh: 'chinese' }

  def self.collection_for_dropdown(i18n_language = :en)
    language_array = @languages.keys.map { |language| [language.to_s, I18n.t(language, scope: 'iso_639_1', locale: i18n_language).capitalize] }
    most_used_languages = [['', '----------'], ['en', I18n.t('en', scope: 'iso_639_1').capitalize], ['de', I18n.t('de', scope: 'iso_639_1').capitalize], ['', '----------']]
    most_used_languages + language_array.sort { |a, b| a[1] <=> b[1] }
  end

  def self.search_strings(iso)
    {
      iso_start: iso.to_s + ' %',
      iso:       '% ' + iso.to_s + ' %',
      en_name:   '%' + I18n.t(iso, scope: 'iso_639_1', locale: :en) + '%',
      de_name:   '%' + I18n.t(iso, scope: 'iso_639_1', locale: :de) + '%',
      own_name:  '%' + @languages[iso.to_sym] + '%'
    }
  end
end
