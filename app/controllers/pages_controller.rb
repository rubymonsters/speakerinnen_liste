class PagesController < ApplicationController
    def home
    @profiles = Profile.is_published.random.limit(8)
    @topics = Profile.tag_counts_on(:topics).sort_by(&:count).reverse.take(16)
    @categories = Category.all
  end
end
