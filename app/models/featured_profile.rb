class FeaturedProfile < ApplicationRecord
  def self.featured_women
    featured = FeaturedProfile.find_by(public: true)
    if featured == nil
      return nil
    else
      featured_profiles = []
      featured.profile_ids.each { | id | featured_profiles << Profile.find(id) }
    end
    featured_profiles
  end
end
