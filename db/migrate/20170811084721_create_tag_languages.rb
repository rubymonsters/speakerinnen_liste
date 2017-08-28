class CreateTagLanguages < ActiveRecord::Migration
  def change
    create_table :tag_languages do |t|
      t.integer :tag_id
      t.string :language

      t.timestamps
    end
  end
end
