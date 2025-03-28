module TranslationHelper
  extend ActiveSupport::Concern

  def build_missing_translations
    I18n.available_locales.each do |locale|
      Mobility.with_locale(locale) do
        self.name ||= "" # Ensure an empty string instead of nil
      end
    end
  end
end
