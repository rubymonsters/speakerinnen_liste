class BlockedEmail < ApplicationRecord
  validates :email, :subject, :body, :contacted_profile_email, presence: true

  scope :reviewed, -> { where(reviewed: true) }
  scope :unreviewed, -> { where(reviewed: false) }
end
