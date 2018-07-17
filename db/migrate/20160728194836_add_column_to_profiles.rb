class AddColumnToProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :profiles, :country, :string
  end
end
