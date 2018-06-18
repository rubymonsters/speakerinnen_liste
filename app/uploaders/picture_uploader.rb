# frozen_string_literal: true

class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :profile do
    process resize_to_fill: [250, 250]
  end

  version :profiles_list do
    process resize_to_fill: [150, 150]
  end

  def extension_white_list
    %w[jpg jpeg gif png]
  end

  def as_json(_options = {})
    {
      'original' => url,
      'profile_small' => profile.url,
      'profile_smallest' => profiles_list.url
    }
  end
end
