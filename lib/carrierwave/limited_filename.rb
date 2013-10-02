module CarrierWave
  module LimitedFilename
    MAX_FILENAME_LENGTH = 64

    def filename
      return if original_filename.blank?

      extension = File.extname(original_filename)
      basename = File.basename(original_filename).parameterize[0...MAX_FILENAME_LENGTH]
      "#{basename}#{extension}"
    end
  end
end
