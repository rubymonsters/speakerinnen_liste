class SearchProfilesByParams
  include Interactor

  def call
    chain = Profile
              .is_published
              .by_region(context.region)
              .search(context.params[:search])

    chain = chain.by_city(context.params[:filter_city]) if context.params[:filter_city]
    chain = chain.by_country(context.params[:filter_country]) if context.params[:filter_country]
    chain = chain.by_language(context.params[:filter_language]) if context.params[:filter_language]
    chain = chain.by_state(context.params[:filter_state]) if context.params[:filter_state]

    # ids feed the aggregations and the page count; only one page gets rendered
    context.profile_ids = chain.reorder(nil).pluck(:id)
    context.profiles = chain.includes(:translations).with_attached_image
  end
end
