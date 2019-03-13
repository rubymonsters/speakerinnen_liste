class DropFeaturedProfiles < ActiveRecord::Migration[5.2]
  def change
    drop_table :featured_profiles
  end
end
