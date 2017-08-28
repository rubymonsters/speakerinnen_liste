class TagLanguage < ActiveRecord::Base
  belongs_to :tag, class_name: 'ActsAsTaggableOn::Tag'

  validates :language,
    inclusion: { in: %w(de en),
    message: "%{value} is not a valid language" }

  validates :language, uniqueness: { scope: :tag_id, message: "language already exists for this tag"}

    def self.allowed_languages
      @available_tag_languages = I18n.available_locales
    end
end
