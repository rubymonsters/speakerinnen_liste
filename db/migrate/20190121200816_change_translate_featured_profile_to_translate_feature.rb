class ChangeTranslateFeaturedProfileToTranslateFeature < ActiveRecord::Migration[5.2]
  def change
    rename_table :featured_profile_translations, :feature_translations
  end
end
