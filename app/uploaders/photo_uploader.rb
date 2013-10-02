require 'carrierwave/limited_filename'

class PhotoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  include CarrierWave::LimitedFilename

  # Choose what kind of storage to use for this uploader:
  storage (Rails.env.production? || Rails.env.staging? ? :fog : :file)

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thread do
    process :resize_to_fit => [640, -1]
  end

  version :uploader do
    process :resize_to_fill => [120, 120]
  end

  def extension_white_list
    %w(jpg jpeg png)
  end

end
