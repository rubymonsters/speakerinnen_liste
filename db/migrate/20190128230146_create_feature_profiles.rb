class CreateFeatureProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :feature_profiles do |t|
      t.references :feature, foreign_key: true
      t.references :profile, foreign_key: true

      t.timestamps
    end
  end
end
