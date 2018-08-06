class AddAdminCommentToProfiles < ActiveRecord::Migration[4.2]
  def change
    add_column :profiles, :admin_comment, :text
  end
end
