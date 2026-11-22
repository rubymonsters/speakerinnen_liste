# frozen_string_literal: true

class Sharepic < ApplicationRecord
  ALLOWED_CONTENT_TYPES = %w[image/png image/jpeg image/webp].freeze
  MAX_FILE_SIZE = 10.megabytes

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [600, 600]
  end

  validates :title, presence: true, length: { maximum: 255 }
  validates :image, presence: true
  validate :image_format_and_size

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(:position, created_at: :desc) }

  private

  def image_format_and_size
    return unless image.attached?

    errors.add(:image, :invalid_content_type) unless ALLOWED_CONTENT_TYPES.include?(image.blob.content_type)
    errors.add(:image, :too_big, max: MAX_FILE_SIZE / 1.megabyte) if image.blob.byte_size > MAX_FILE_SIZE
  end
end
