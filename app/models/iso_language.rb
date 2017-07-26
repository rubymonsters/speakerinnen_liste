class IsoLanguage
  def self.all
    # we read the list of language-codes directly from the de translation (config/locales/languages.de.yml)file
    # to avoid duplication
    I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    translations = I18n.backend.send(:translations)
    translations[:de][:iso_639_1].keys.map(&:to_s).sort
  end

  def self.top_list
    %w{de el en es fr it nl pl pt ru sv tr zh}
  end

  def self.rest_list
    all - top_list
  end

  def self.from_string(str)
    code = case str.length
    when 1
      code_from_single_letter(str)
    when 2
      code_from_two_letter(str)
    else
      code_from_word(str)
    end
    code = special_cases(str) unless code
    puts "not matched: #{str}" unless code
    code
  end

  def self.special_cases(str)
    return "fr" if str == "Französich"
    return "fr" if str == "Franzoesisch"
    return "fr" if str == "Francais"
    return "fr" if str == "Français"
    return "fr" if str == "français"
    return "nl" if str == "Hollaendisch"
    return "nl" if str == "Nederlands"
    return "nn" if str == "Norsk"
    return "it" if str == "Italenisch"
    return "it" if str == "italien"
    return "ru" if str == "Russich"
    return "fa" if str == "Farsi"
    return "de" if str == "Deutsh"
    return "de" if str == "Deustch"
    return "de" if str == "dt"
    return "de" if str == "deustch"
    return "pt" if str == "Portugues"
    return "es" if str == "espanol"
    return "es" if str == "Español"
    return "en" if str == "ENG"
    return "en" if str == "engl"
    return "sv" if str == "Svenska"
    return "ch" if str == "CH"

  end

  def self.code_from_single_letter(str)
    return "de" if str == "D"
    return "en" if str == "E"
    return "fr" if str == "F"
  end

  def self.code_from_two_letter(str)
    I18n.t('iso_639_1').keys.map(&:to_s).find{|iso| iso == str.downcase}
  end

  def self.code_from_word(str)
    lang_name = I18n.t('iso_639_1', locale: :de).values.map(&:to_s).find{|lang| str.downcase =~ Regexp.new(lang)}
    iso = I18n.t('iso_639_1', locale: :de).to_a.map(&:reverse).to_h[lang_name].try(:to_s)
    return iso if iso
    lang_name = I18n.t('iso_639_1', locale: :en).values.map(&:to_s).find{|lang| str.downcase =~ Regexp.new(lang)}
    I18n.t('iso_639_1', locale: :en).to_a.map(&:reverse).to_h[lang_name].try(:to_s)
  end

  def self.all_longnames_with_keys
    IsoLanguage.all.map {|l| [I18n.t("#{l}", scope: 'iso_639_1').capitalize, l] }
  end
end
