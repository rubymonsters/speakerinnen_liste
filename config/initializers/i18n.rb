module I18n

  def self.name_for_locale(locale)
    self.with_locale(locale) { self.translate("i18n.language.name") }
  rescue I18n::MissingTranslationData
    locale.to_s
  end

end
