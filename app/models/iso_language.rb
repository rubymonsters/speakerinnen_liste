class IsoLanguage
  def self.all
    # we read the list of language-codes directly from the translation file
    # to avoid duplication
    I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    translations = I18n.backend.send(:translations)
    translations[:de][:iso_639_1].keys.sort
  end

  def self.top_list
    %i{ar bn de el en es fa fr he hi it ja nl pl pt ru tr ur zh}
  end

  def self.rest_list
    all - top_list
  end
end
