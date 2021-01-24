class AddPrecisionToCreatedUpdatedAt < ActiveRecord::Migration[6.0]
  def change
    change_column :category_translations, :created_at, :datetime, :precision => 6
    change_column :category_translations, :updated_at, :datetime, :precision => 6
    change_column :feature_translations, :created_at, :datetime, :precision => 6
    change_column :feature_translations, :updated_at, :datetime, :precision => 6
    change_column :profile_translations, :created_at, :datetime, :precision => 6
    change_column :profile_translations, :updated_at, :datetime, :precision => 6
  end
end
