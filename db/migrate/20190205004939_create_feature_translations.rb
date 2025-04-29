class CreateFeatureTranslations < ActiveRecord::Migration[7.1]
  def change
    create_table :feature_translations do |t|
      t.references :feature, null: false, foreign_key: true
      t.string :locale, null: false

      t.text :title
      t.text :description

      t.timestamps
    end

    add_index :feature_translations, [:feature_id, :locale], unique: true
  end
end
