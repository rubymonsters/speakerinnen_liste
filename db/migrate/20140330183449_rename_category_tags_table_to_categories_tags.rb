class RenameCategoryTagsTableToCategoriesTags < ActiveRecord::Migration
  def change
    rename_table :category_tags, :categories_tags
  end

end
