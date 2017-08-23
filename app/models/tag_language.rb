class TagLanguage < ActiveRecord::Base
  belongs_to :tag, class_name: 'ActsAsTaggableOn::Tag'

  validates :language,
    inclusion: { in: %w(de en),
    message: "%{value} is not a valid language" }

    def self.tag_languages
      TagLanguage.all.pluck(:language).uniq
    end
end
