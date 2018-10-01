class FeaturedProfile < ApplicationRecord
  def self.featured_women
    featured_ids = FeaturedProfile.find_by(public: true).profile_ids
    featured_profiles = []
    featured_ids.each { | id | featured_profiles << Profile.find(id) }
    featured_profiles
  end
end
