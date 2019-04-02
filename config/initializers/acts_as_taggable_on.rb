ActsAsTaggableOn.remove_unused_tags = true

ActsAsTaggableOn.force_lowercase = true

ActsAsTaggableOn::Tag.class_eval do
  has_and_belongs_to_many :categories
  has_many :profiles
  has_many :tags_locale_languages
  has_many :locale_languages, through: :tags_locale_languages

  #validates_uniqueness_of :locale_languages

  # make sure that the joined table entry gets destroyed after deleting the tag
  #accepts_nested_attributes_for :tag_languages, allow_destroy: true
  scope :translated_in_current_language_and_not_translated, -> (lang_str) { ActsAsTaggableOn::Tag.left_outer_joins(:locale_languages)
                                                                .where(locale_languages: { id: nil })
                                                                .or( ActsAsTaggableOn::Tag.left_outer_joins(:locale_languages)
                                                                .where(:locale_languages => {:iso_code => lang_str }) ) }

  scope :with_language, -> (lang_str) { ActsAsTaggableOn::Tag.joins(:locale_languages).where(:locale_languages => {:iso_code => lang_str }).distinct }

  scope :without_language, -> { ActsAsTaggableOn::Tag.left_outer_joins(:locale_languages).where(locale_languages: { id: nil }) }

  scope :with_published_profile, -> { ActsAsTaggableOn::Tag.joins(:taggings).joins("INNER JOIN profiles ON taggings.taggable_id=profiles.id").where(:profiles => { :published => true}).distinct }

  scope :belongs_to_category, -> (cat_id) { ActsAsTaggableOn::Tag.joins(:categories).where(:categories => { :id => cat_id }).distinct }

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
#ActsAsTaggableOn::Tag
  #.joins(:taggings)
  #.joins("INNER JOIN profiles ON taggings.taggable_id=profiles.id")
  #.joins(:categories)
  #.where("categories.id= ? AND profiles.published=true", params[:category_id])
  #.joins(:tag_languages)
  #.where("tag_languages.language= ?", I18n.locale)
  #.distinct`
