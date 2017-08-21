ActsAsTaggableOn.remove_unused_tags = true

ActsAsTaggableOn.force_lowercase = true

ActsAsTaggableOn::Tag.class_eval do
  has_and_belongs_to_many :categories
  has_many :profiles
  has_many :tag_languages

  accepts_nested_attributes_for :tag_languages

  def set_tag_language(tag_id, language)
    TagLanguage.create(tag_id: tag_id, language: language)
  end

  def merge(wrong_tag)
    # update all taggings on any of these wrong tags to now point to the correct tag that we keep
    Profile.tagged_with(wrong_tag).each do |profile|
      profile.topic_list.remove(wrong_tag.name)
      profile.topic_list.add(self.name)
      profile.save
      profile.reload
    end
  end

end

