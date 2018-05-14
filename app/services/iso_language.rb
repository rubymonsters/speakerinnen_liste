class IsoLanguage
  def self.all
    # we read the list of language-codes directly from the de translation (config/locales/languages.de.yml)file
    # to avoid duplication
    I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    translations = I18n.backend.send(:translations)
    translations[:de][:iso_639_1].keys.map(&:to_s).sort
  end

  def self.top_list
    %w[de el en es fr it nl pl pt ru sv tr zh]
  end

  def self.rest_list
    all - top_list
  end

  def self.all_languagenames_with_iso
    IsoLanguage.all.map { |l| [I18n.t(l.to_s, scope: 'iso_639_1').capitalize, l] }
  end
end
