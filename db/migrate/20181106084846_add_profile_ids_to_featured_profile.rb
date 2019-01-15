# frozen_string_literal: true

class AddProfileIdsToFeaturedProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :featured_profiles, :profile_ids, :integer, array: true, default: []
  end
end
