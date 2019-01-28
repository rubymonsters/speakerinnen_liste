class RenameFeaturedProfileIdInFeatureTranslationsToFeatureId < ActiveRecord::Migration[5.2]
  def change
    rename_column :feature_translations, :featured_profile_id, :feature_id
  end
end
