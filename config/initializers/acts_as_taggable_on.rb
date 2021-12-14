ActsAsTaggableOn.remove_unused_tags = true

ActsAsTaggableOn.force_lowercase = true

ActsAsTaggableOn::Tag.class_eval do
  has_and_belongs_to_many :categories
  has_many :profiles, through: :taggings, source: :taggable, source_type: "Profile"
  has_many :tags_locale_languages
  has_many :locale_languages, through: :tags_locale_languages

  #validates_uniqueness_of :locale_languages

  # make sure that the joined table entry gets destroyed after deleting the tag
  #accepts_nested_attributes_for :tag_languages, allow_destroy: true
  scope :translated_in_current_language_and_not_translated,
    -> (lang_str) { self
          .left_outer_joins(:locale_languages)
          .where(locale_languages: { id: nil })
          .or(self.left_outer_joins(:locale_languages)
          .where(:locale_languages => { :iso_code => lang_str }))
        }

  scope :with_language, -> (lang_str) { self.joins(:locale_languages).where(:locale_languages => {:iso_code => lang_str }).distinct }

  scope :without_language, -> { self.left_outer_joins(:locale_languages).where(locale_languages: { id: nil }) }

  scope :with_published_profile, -> { self.joins(:taggings).joins("INNER JOIN profiles ON taggings.taggable_id=profiles.id").where(:profiles => { :published => true}).distinct }

  scope :belongs_to_category, -> (cat_id) { self.joins(:categories).where(:categories => { :id => cat_id }).distinct }

  scope :with_regional_profile, -> (region) { region ? self.joins(:profiles).where(profiles: { state: region }).distinct : self }

  scope :belongs_to_more_than_one_profile, -> { self.joins(:taggings).where("taggings_count > ?", 1) }

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
