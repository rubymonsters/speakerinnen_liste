# Encoding: utf-8

class SearchLanguages
  @languages = {  en: 'english',
                  de: 'deutsch',
                  fr: 'français',
                  es: 'espaniol'}
  #%w(en de sp fr bg ar da el ce he hr es af be bg fi he is it ku hu no pl pt ro ru sk sl sr sv uk zh)

  def self.collection_for_dropdown(i18n_language=:en)
    @languages.keys.map {|l| [l.to_s, I18n.t(l, scope: 'iso_639_1', locale: i18n_language).capitalize]}
  end

  def self.search_strings(iso)
    {
    iso_start: iso.to_s+' %',
    iso:       '% '+iso.to_s+' %',
    en_name:   '%'+I18n.t(iso, scope: 'iso_639_1', locale: :en)+'%',
    de_name:   '%'+I18n.t(iso, scope: 'iso_639_1', locale: :de)+'%',
    own_name:  '%'+@languages[iso.to_sym]+'%'
    }
  end
end
