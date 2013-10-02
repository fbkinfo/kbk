class VideoDecorator < Draper::Decorator
  include AutoHtml

  delegate_all

  def embed_code
    auto_html(object.body) do
      image
      youtube(width: 640, height: 400)
      vimeo(width: 640, height: 400)
    end
  end
end
