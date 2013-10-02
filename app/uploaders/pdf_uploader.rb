require 'carrierwave/s3_cache_url'

class PdfUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::S3CacheUrl

  storage (Rails.env.production? || Rails.env.staging? ? :fog : :file)

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def prepared_url
    if url.blank?
      prepare_pdf
    end

    url
  end

  private

  def prepare_pdf
    builder = SnapshotPdfBuilder.new(model.snapshots.sorted.to_a)
    file = random_filename
    store!(UploadableStringIO.new(file, builder.render))
    model.update_column(:pdf, file)
  end

  def random_filename
    "#{SecureRandom.uuid}.pdf"
  end
end
