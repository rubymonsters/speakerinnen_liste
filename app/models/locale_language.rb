# frozen_string_literal: true

class LocaleLanguage < ApplicationRecord
  has_many :tags_locale_languages
  has_many(
    :tags,
    through: :tags_locale_languages,
    class_name: 'ActsAsTaggableOn::Tag'
  )
end
