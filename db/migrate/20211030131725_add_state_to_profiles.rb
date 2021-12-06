class AddStateToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :state, :string
  end
end
