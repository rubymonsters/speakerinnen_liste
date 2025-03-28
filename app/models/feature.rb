class Feature < ApplicationRecord
  has_many :feature_profiles
  has_many :profiles, through: :feature_profiles, dependent: :destroy

  validates :title, presence: true
  
  extend Mobility
  translates :title, :description

  include TranslationHelper

  scope :published_feature, -> { includes({ profiles: [:translations, :image_attachment] }, :translations).where(public: true) }
end
