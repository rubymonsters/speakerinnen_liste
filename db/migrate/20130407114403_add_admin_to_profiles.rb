class AddAdminToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :admin, :boolean
  end
end
