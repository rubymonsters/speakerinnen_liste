class SearchProfiles
  include Interactor

  def call
    chain = Profile
              .includes(:translations)
              .with_attached_image
              .is_published
              .by_region(context.region)
              .search(context.params[:search])

    chain = chain.by_city(context.params[:filter_city]) if context.params[:filter_city]
    chain = chain.by_country(context.params[:filter_country]) if context.params[:filter_country]
    chain = chain.by_language(context.params[:filter_language]) if context.params[:filter_language]
    chain = chain.by_state(context.params[:filter_state]) if context.params[:filter_state]

    context.profiles = chain.map(&:profile_card_details)
  end
end
