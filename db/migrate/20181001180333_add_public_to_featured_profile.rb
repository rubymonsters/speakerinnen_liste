class AddPublicToFeaturedProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :featured_profiles, :public, :boolean
  end
end
