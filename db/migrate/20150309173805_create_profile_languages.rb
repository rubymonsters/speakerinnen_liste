class CreateProfileLanguages < ActiveRecord::Migration
  def change
    create_table :profile_languages do |t|
      t.integer :profile_id
      t.string :iso_639_1

      t.timestamps
    end
    add_index :profile_languages, :profile_id
    add_index :profile_languages, :iso_639_1
  end
end
