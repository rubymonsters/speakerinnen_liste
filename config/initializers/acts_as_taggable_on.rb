#If you would like to remove unused tag objects after removing taggings
ActsAsTaggableOn.remove_unused_tags = true
#If you want to change the default delimiter (it defaults to ','). You can also pass in an array of delimiters such as ([',', '|']):
ActsAsTaggableOn.delimiter = [',', ';']

ActsAsTaggableOn.force_lowercase = true

ActsAsTaggableOn::Tag.class_eval do
  has_and_belongs_to_many :categories
  #attr_accessible :name

  def merge(wrong_tag)
    # update all taggings on any of these tags to now point to the tag that we keep
    ActsAsTaggableOn::Tagging.where(tag_id: wrong_tag.id).update_all(tag_id: self.id)
    wrong_tag.destroy
  end
end
