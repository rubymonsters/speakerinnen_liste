class DropTagLanguagesTable < ActiveRecord::Migration
 def up
    drop_table :tag_languages
  end
  def down
    create_table :tag_languages do |t|
      t.integer :tag_id
      t.string :language

      t.timestamps
    end
  end
end
