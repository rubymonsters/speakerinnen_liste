class RemoveWebsiteFromProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles, :website, :string
  end
end
