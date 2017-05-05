require 'active_support/concern'

module HasPicture
  extend ActiveSupport::Concern

  included do
    mount_uploader :picture, PictureUploader
    #validate :file_size
  end

  def file_size
    return unless picture.size.to_f / (1000 * 1000) > 1

    errors.add(:picture, I18n.t('error_messages.picture_too_big'))
  end
end
