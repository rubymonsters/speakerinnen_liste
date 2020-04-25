class AddAttributesToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :copyright, :string
    add_column :profiles, :personal_note, :string, limit: 175
    add_column :profiles, :willing_to_travel, :Boolean
    add_column :profiles, :nonprofit, :Boolean
  end
end
