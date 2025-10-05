class CreateBlockedEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :blocked_emails do |t|
      t.string :name
      t.string :email
      t.string :subject
      t.text :body
      t.string :contacted_profile_email
      t.string :reason
      t.datetime :sent_at

      t.timestamps
    end
  end
end
