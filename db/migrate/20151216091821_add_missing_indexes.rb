class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :medialinks, :profile_id
    add_index :categories_tags, :tag_id
    add_index :categories_tags, [:category_id, :tag_id]
    add_index :categories_tags, :category_id
  end
end
