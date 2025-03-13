class AddSocialMediaLinksToProfiles < ActiveRecord::Migration[7.1]
  def change
    add_column :profiles, :instagram, :string
    add_column :profiles, :linkedin, :string
    add_column :profiles, :bluesky, :string
    add_column :profiles, :mastodon, :string
  end
end
