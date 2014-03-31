class RemoveCreatedAtAndUpdatedAtColumnsFromCategoriesTags < ActiveRecord::Migration
  def up
    remove_column :categories_tags, :created_at
    remove_column :categories_tags, :updated_at
  end

  def down
    add_column :categories_tags, :created_at, :datetime
    add_column :categories_tags, :updated_at, :datetime
  end
end
