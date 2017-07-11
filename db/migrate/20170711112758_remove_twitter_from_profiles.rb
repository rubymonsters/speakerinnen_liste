class RemoveTwitterFromProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles, :twitter, :string
  end
end
