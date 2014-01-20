class AddPublishedToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :published, :boolean, default: false
  end
end
