class CreateBlockedEmails < ActiveRecord::Migration[7.1]
  def change
    create_table :blocked_emails do |t|
      t.string :email
      t.string :subject
      t.text :body
      t.string :reason

      t.timestamps
    end
  end
end
