class CreateCategoryTags < ActiveRecord::Migration[4.2]
  def change
    create_table :category_tags do |t|
      t.integer :category_id
      t.integer :tag_id
  
      t.timestamps
    end
  end
end
