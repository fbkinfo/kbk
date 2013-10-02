require 'spec_helper'

describe LinkDecorator do
  describe "#source" do
    context "on link with valid url" do
      it "returns valid source" do
        link = Link.new(url: "http://kavkaz-center.com")
        expect(link.decorate.source).to eq "kavkaz-center.com"
      end
    end

    context "on link with invalid url" do
      it "returns nil" do
        link = Link.new(url: "http://")
        expect(link.decorate.source).to eq nil
      end
    end
  end
end
