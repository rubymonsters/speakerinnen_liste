class PagesController < ApplicationController
    def home
    @profiles = Profile.is_published.limit(8)
    @topics = Profile.tag_counts_on(:topics).sort_by(&:count).reverse.take(15)
  end
end
