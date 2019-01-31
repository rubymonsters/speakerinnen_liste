class Feature < ApplicationRecord
  has_many :feature_profiles
  has_many :profiles, through: :feature_profiles, dependent: :destroy
  
  validates :title, presence: true
  translates :title, :description
  globalize_accessors :locales => [:de, :en], :attributes => [:title, :description]

  def ids
    profile_ids.map do | id |
      Profile.find(id) if Profile.exists?(id)
    end
  end
end
