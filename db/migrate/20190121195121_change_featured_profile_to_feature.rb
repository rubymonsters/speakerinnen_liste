class ChangeFeaturedProfileToFeature < ActiveRecord::Migration[5.2]
  def change
    rename_table :featured_profiles, :features
  end
end
