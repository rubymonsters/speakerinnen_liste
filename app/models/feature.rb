class Feature < ApplicationRecord
  validates :title, presence: true
  translates :title, :description
  globalize_accessors :locales => [:de, :en], :attributes => [:title, :description]

  def ids
    profile_ids.map do | id |
      Profile.find(id) if Profile.exists?(id)
    end
  end
end
