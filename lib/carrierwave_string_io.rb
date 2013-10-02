class CarrierwaveStringIO < StringIO
  attr_accessor :content_type, :original_filename

  def initialize(string)
    image = split_base64(string)
    content = Base64.decode64(image[:data])

    self.content_type = image[:type]
    self.original_filename = "photo.#{image[:extension]}"

    super(content)
  end

  private

  def split_base64(uri)
    if uri.match(%r{^data:(.*?);(.*?),(.*)$})
      return {
        type:      $1, # "image/png"
        encoder:   $2, # "base64"
        data:      $3, # data string
        extension: $1.split('/')[1] # "png"
      }
    end
  end

end
