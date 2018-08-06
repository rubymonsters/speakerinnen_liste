class AddPublishedToProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :profiles, :published, :boolean, default: false
  end
end
