require 'carrierwave/s3_cache_url'
require 'carrierwave/limited_filename'

class AttachementUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  include CarrierWave::S3CacheUrl
  include CarrierWave::LimitedFilename

  storage (Rails.env.production? || Rails.env.staging? ? :fog : :file)

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    original_filename.parameterize.slice(0..80) if original_filename
  end

end
