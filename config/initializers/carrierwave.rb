CarrierWave.configure do |config|
  bucket = Settings.s3.bucket
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => Settings.s3.access_key_id,
    :aws_secret_access_key  => Settings.s3.secret_access_key,
    :region                 => 'eu-west-1',
    :host                   => "#{bucket}.s3.amazonaws.com",
    :endpoint               => 'http://s3-eu-west-1.amazonaws.com'
  }
  config.fog_directory = bucket

  # Heroku compatibility
  # See https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3A-Make-Carrierwave-work-on-Heroku
  # config.cache_dir = "#{Rails.root}/tmp/uploads" if Rails.env.production?

  if Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  end
end

class UploadableStringIO < StringIO
  attr_accessor :filepath

  def initialize(*args)
    super(*args[1..-1])
    @filepath = args[0]
  end

  def original_filename
    File.basename(filepath)
  end
end

# monkeypatch from https://github.com/gzigzigzeo/carrierwave-meta/issues/4#issuecomment-7405487
module CarrierWave
  module Storage
    class Fog
      class File
        def original_filename
          ::File.basename(path)
        end
      end
    end
  end
end
