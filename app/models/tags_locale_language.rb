class TagsLocaleLanguage < ActiveRecord::Base
  belongs_to :tag, class_name: 'ActsAsTaggableOn::Tag'
  belongs_to :locale_language
end
