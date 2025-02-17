class AddLinksToISocialMediaAccountToProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :profiles, :link_to_instagram, :string
    add_column :profiles, :link_to_linkdin, :string
    add_column :profiles, :link_to_bluesky, :string
    add_column :profiles, :link_to_mastodon, :string
  end
end
