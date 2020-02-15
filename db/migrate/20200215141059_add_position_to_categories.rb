class AddPositionToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :position, :integer, default: 0
  end
end
