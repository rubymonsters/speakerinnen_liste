class RemoveTwitterFromProfiles < ActiveRecord::Migration[4.2]
  def change
    remove_column :profiles, :twitter, :string
  end
end
