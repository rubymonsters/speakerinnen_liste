#If you would like to remove unused tag objects after removing taggings
ActsAsTaggableOn.remove_unused_tags = true
#If you want to change the default delimiter (it defaults to ','). You can also pass in an array of delimiters such as ([',', '|']):
ActsAsTaggableOn.delimiter = [',', ';']

ActsAsTaggableOn.force_lowercase = true

ActsAsTaggableOn::Tag.class_eval do
  has_and_belongs_to_many :categories
  #attr_accessible :name

  #def self.merge(attrs)
    ## perform the merge
    #tags = ActsAsTaggableOn::Tag.where(id: attrs[:id]).to_s
    #keep = tags.shift # merge all others into the first one
    #merge_ids = tags.map(&:id)
    ## update all taggings on any of these tags to now point to the tag that we keep
    #ActsAsTaggableOn::Tagging.where(tag_id: merge_ids).update_all(tag_id: keep.id)
    ## now that these tags have no taggings anymore we can delete them
    #ActsAsTaggableOn::Tag.where(id: merge_ids).delete_all
  #end
end
