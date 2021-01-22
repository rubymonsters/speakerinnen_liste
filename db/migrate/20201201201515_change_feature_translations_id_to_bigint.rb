class ChangeFeatureTranslationsIdToBigint < ActiveRecord::Migration[5.2]
  def change
    change_column :feature_translations, :feature_id, :bigint
  end
end
