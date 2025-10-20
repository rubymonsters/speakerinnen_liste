class BlockedEmail < ApplicationRecord
  validates :email, :subject, :body, :contacted_profile_email, presence: true
end
