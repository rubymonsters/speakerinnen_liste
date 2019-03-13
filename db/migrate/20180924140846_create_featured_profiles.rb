class CreateFeaturedProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :featured_profiles do |t|
      t.string :title
      t.text :description
      t.string :profile_ids, array: true, default: []

      t.timestamps
    end
  end
end
