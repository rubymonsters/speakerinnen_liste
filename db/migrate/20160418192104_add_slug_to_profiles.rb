class AddSlugToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :slug, :string
    add_index :profiles, :slug, unique: true
  end
end
