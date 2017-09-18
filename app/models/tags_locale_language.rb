class TagsLocaleLanguage < ActiveRecord::Base
  belongs_to :tag
  belongs_to :locale_language
end
