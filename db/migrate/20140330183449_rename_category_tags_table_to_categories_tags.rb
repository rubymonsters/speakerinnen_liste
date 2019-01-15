# frozen_string_literal: true

class RenameCategoryTagsTableToCategoriesTags < ActiveRecord::Migration[4.2]
  def change
    rename_table :category_tags, :categories_tags
  end
end
