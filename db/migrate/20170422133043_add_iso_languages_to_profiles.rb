class AddIsoLanguagesToProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :profiles, :iso_languages, :string
  end
end
