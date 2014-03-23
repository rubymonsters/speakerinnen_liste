class AddAdminCommentToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :admin_comment, :text
  end
end
