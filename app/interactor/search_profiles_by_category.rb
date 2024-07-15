class SearchProfilesByCategory
  include Interactor
  requires :category_id

  def call
    category = Category.find_by(id: context.category_id)

    if category.nil?
      context.fail!(message: I18n.t('flash.profiles.category_not_found'))
    else
      context.category = category
      context.profiles = profiles_for_category(category)
    end
  end

  private

  def profiles_for_category(category)
    tag_names = ActsAsTaggableOn::Tag
                  .with_published_profile
                  .belongs_to_category(category.id)
                  .translated_in_current_language_and_not_translated(I18n.locale)
                  .pluck(:name)

    Profile.with_attached_image
           .is_published
           .by_region(context.region)
           .includes(:topics)
           .where(tags: { name: tag_names })
  end
end
