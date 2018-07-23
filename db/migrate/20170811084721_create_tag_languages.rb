class CreateTagLanguages < ActiveRecord::Migration[4.2]
  def change
    create_table :tag_languages do |t|
      t.integer :tag_id
      t.string :language

      t.timestamps
    end
  end
end
