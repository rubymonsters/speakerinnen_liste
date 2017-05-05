class AddIsoLanguagesToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :iso_languages, :string
  end
end
