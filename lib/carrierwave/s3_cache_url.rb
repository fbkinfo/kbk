module CarrierWave
  module S3CacheUrl
    def url(*args)
      target_url = super
      if s3_storage? && (target_url =~ /amazonaws.com/)
        timestamp = model.try(:updated_at).try(:to_i)
        target_url = target_url.sub('http://s3-eu-west-1.amazonaws.com', assets_host)
        "#{target_url}?_=#{timestamp}"
      else
        target_url
      end
    end

    def s3_storage?
      storage.is_a?(CarrierWave::Storage::Fog)
    end

    def assets_host
      if is_a?(ScanUploader)
        Settings.s3.relative_url
      else
        Settings.s3.subdomain_url
      end
    end
  end
end
