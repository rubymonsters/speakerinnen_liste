class AddSlugToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :slug, :string
    add_index :profiles, :slug, unique: true
    Profile.find_each(&:save)  # this creates slugs for existing Profiles
  end
end
