class Feature < ApplicationRecord
  has_many :feature_profiles
  has_many :profiles, through: :feature_profiles, dependent: :destroy

  validates :title, presence: true
  translates :title, :description
  globalize_accessors :locales => [:de, :en], :attributes => [:title, :description]

  scope :published_feature, -> { includes({ profiles: [:translations, :image_attachment] }, :translations).where(public: true) }
end
