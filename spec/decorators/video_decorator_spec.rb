require 'spec_helper'

describe VideoDecorator do
  describe "#embed_code" do
    context "on record with youtube link" do
      it "returns youtube code" do
        video = Video.new(body: "http://youtube.com/watch?v=n8tsfHoEPlU")
        code = video.decorate.embed_code

        expect(code).to include('<iframe width="640" height="400" src="//www.youtube.com/embed/n8tsfHoEPlU"')
      end
    end

    context "on record with vimeo link" do
      it "returns vimeo code" do
        video = Video.new(body: "http://vimeo.com/67069182")
        code = video.decorate.embed_code

        expect(code).to include('<iframe src="//player.vimeo.com/video/67069182')
      end
    end
  end
end
