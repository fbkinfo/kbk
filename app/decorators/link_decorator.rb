require 'uri'

class LinkDecorator < Draper::Decorator
  delegate_all

  def source
    URI.parse(object.url).host
  rescue URI::InvalidURIError
  end

end
