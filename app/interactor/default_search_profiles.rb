class DefaultSearchProfiles
  include Interactor

  def call
    context.profiles = profiles_for_index
  end

  private


  def profiles_for_index
      Profile.with_attached_image
        .is_published
        .by_region(context.current_region)
        .includes(:translations)
        .main_topic_translated_in(I18n.locale)
        .order(created_at: :desc)
  end
end
