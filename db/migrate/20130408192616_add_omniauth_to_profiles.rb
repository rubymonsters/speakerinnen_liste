class AddOmniauthToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :provider, :string
    add_column :profiles, :uid, :string
  end
end
