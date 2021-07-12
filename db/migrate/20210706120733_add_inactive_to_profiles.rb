class AddInactiveToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :inactive, :boolean, default: false
  end
end
