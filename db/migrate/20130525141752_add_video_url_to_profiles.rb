class AddVideoUrlToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :video_url, :string
  end
end
