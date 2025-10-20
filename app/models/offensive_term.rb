class OffensiveTerm < ApplicationRecord
  before_validation do
    self.word&.strip!
    self.word&.downcase!
  end

  validates :word, presence: true, uniqueness: { case_sensitive: false }
end
