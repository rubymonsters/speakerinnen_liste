class AddMediaUrlToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :media_url, :string
  end
end

