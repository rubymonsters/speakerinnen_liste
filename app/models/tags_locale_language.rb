# frozen_string_literal: true

class TagsLocaleLanguage < ApplicationRecord
  belongs_to :tag, class_name: 'ActsAsTaggableOn::Tag'
  belongs_to :locale_language
end
