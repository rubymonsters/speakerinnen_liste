class AddOmniauthToProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :profiles, :provider, :string
    add_column :profiles, :uid, :string
  end
end
