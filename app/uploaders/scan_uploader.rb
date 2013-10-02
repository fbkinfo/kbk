require 'carrierwave/s3_cache_url'

class ScanUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::Meta
  include CarrierWave::S3CacheUrl

  storage (Rails.env.production? || Rails.env.staging? ? :fog : :file)

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :store_meta

  version :preview do
    process :resize_to_fit => [640, -1]
    process :convert => 'jpg'
    def full_filename(*)
      'preview.jpg'
    end
  end

  version :thumb do
    process :resize_to_fit => [80, -1]
    process :convert => 'jpg'
    def full_filename(*)
      'thumb.jpg'
    end
  end

  def extension_white_list
    %w(jpg jpeg png pdf)
  end
end
