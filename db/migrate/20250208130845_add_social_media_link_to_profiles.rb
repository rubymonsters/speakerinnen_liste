class AddSocialMediaLinkToProfiles < ActiveRecord::Migration[6.1]
  def change
    add_column :profiles, :social_media_link, :string
  end
end
