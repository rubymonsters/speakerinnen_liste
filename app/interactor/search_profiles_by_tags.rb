
class SearchProfilesByTags
  include Interactor

  def call
    @tags = context.tags.split(/\s*,\s*/)
    last_tag = @tags.last
    last_tag_id = ActsAsTaggableOn::Tag.where(name: last_tag).last.id
    context.tags = @tags
    context.profiles = profiles_with_tags(@tags)
    context.category = Category.select{|cat| cat.tag_ids.include?(last_tag_id)}.last
  end

  private

  def profiles_with_tags(tags)
    Profile.is_published
           .by_region(context.region)
           .includes([:translations])
           .has_tags(tags)
  end
end
