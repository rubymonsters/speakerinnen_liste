class DashboardController < ApplicationController

	def index
    	@profiles = Profile.limit(8)
    	@topics = Profile.tag_counts_on(:topics).sort_by(&:count).reverse.take(15)
	end
end
