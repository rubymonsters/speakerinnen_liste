# frozen_string_literal: true

class FeaturedProfile < ApplicationRecord
  validates :title, presence: true
  translates :title, :description
  globalize_accessors locales: %i[de en], attributes: %i[title description]

  def ids
    profile_ids.map do |id|
      Profile.find(id) if Profile.exists?(id)
    end
  end
end
