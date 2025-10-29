class GetAllProfiles
  include Interactor

  def call
    context.profiles = Profile
      .with_attached_image
      .is_published
      .by_region(context.region)
      .includes(:translations)
      .main_topic_translated_in(I18n.locale)
      .order(created_at: :desc)
  end

end
