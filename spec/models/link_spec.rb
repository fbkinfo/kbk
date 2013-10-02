require 'spec_helper'

describe Link do
  describe "url preparing" do
    it "adds http to urls without protocol" do
      link = Link.new(url: "yandex.ru")
      link.save

      expect(link.url).to eq("http://yandex.ru")
    end

    it "doesn't add http to urls with http protocol" do
      link = Link.new(url: "http://yandex.ru")
      link.save

      expect(link.url).to eq("http://yandex.ru")
    end

    it "doesn't add http to urls with https protocol" do
      link = Link.new(url: "https://yandex.ru")
      link.save

      expect(link.url).to eq("https://yandex.ru")
    end
  end
end
