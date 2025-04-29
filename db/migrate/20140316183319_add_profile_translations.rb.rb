class AddProfileTranslations < ActiveRecord::Migration[7.1]
  def change
    create_table :profile_translations do |t|
      t.references :profile, null: false, foreign_key: true
      t.string :locale, null: false

      t.string :main_topic
      t.text :bio

      t.timestamps
    end

    add_index :profile_translations, [:profile_id, :locale], unique: true
  end
end
