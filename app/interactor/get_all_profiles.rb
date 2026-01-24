class GetAllProfiles
  include Interactor

  def call
    base_query = Profile
                 .select('profiles.*')
                 .is_published
                 .by_region(context.region)
                 .main_topic_translated_in(I18n.locale)
                 .order(created_at: :desc)

    context.profiles = base_query.limit(50) # pagy will handle pagination
    context.profiles = context.profiles.preload(:translations, :image_attachment, :image_blob)
  end
end
