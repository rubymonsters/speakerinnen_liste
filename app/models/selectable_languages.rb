class SelectableLanguages

  def self.to_a
    LanguageList::COMMON_LANGUAGES.select do |language|
      language_list.include?(language.iso_639_1)
    end
  end

  private

  def self.language_list
    %w(en de sp fr bg ar da el ce he hr es)
  end

end
