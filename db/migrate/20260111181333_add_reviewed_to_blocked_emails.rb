class AddReviewedToBlockedEmails < ActiveRecord::Migration[8.0]
  def change
    add_column :blocked_emails, :reviewed, :boolean, default: false, null: false 
  end
end
