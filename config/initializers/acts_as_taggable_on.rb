#If you would like to remove unused tag objects after removing taggings
ActsAsTaggableOn.remove_unused_tags = true
#If you want to change the default delimiter (it defaults to ','). You can also pass in an array of delimiters such as ([',', '|']):
ActsAsTaggableOn.delimiter = [',', ';']

ActsAsTaggableOn.force_lowercase = true

ActsAsTaggableOn::Tag.class_eval do
  has_and_belongs_to_many :categories
  has_many :profiles
  #attr_accessible :name

  def merge(wrong_tag)
    # update all taggings on any of these tags to now point to the tag that we keep
    #
    # wrong_tag.profiles
    # iterieren remove wrong tag
    # add self tag
    #
    Profile.tagged_with(wrong_tag).each do |profile|
      profile.topic_list.remove(wrong_tag.name)
      profile.topic_list.add(self)
      profile.save
      profile.reload
    end
    #
    #ActsAsTaggableOn::Tagging.where(tag_id: wrong_tag.id).count
    #ActsAsTaggableOn::Tagging.where(tag_id: wrong_tag.id).update_all(tag_id: self.id)
    #p self.taggings_count
    #self.taggings_count += 1
    #self.save!
    #p 'im controller: taggings_count'
    #p self.taggings_count
    #wrong_tag.destroy
  end
end
