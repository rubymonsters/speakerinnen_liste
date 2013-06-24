class DashboardController < ApplicationController

	def index
    @profiles = Profile.limit(10)
	end
end
