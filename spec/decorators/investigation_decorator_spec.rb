require 'spec_helper'

describe InvestigationDecorator do
  describe "#description" do
    context "with blank description" do
      it "returns nil" do
        decorator = Investigation.new(description: nil).decorate
        expect(decorator.description).to be_nil
      end
    end

    it "converts link" do
      document = create(:document)
      text = "begin <a href=\"http://fbk.info/documents/#{document.id}\">hiall</a> end"
      decorator = create(:investigation, description: text).decorate

      expect(decorator.description).to include("/investigations/#{document.investigation_id}#document_#{document.id}")
    end

    it "converts to markdown" do
      text = '**важное** [link](http://fbk.info)'
      decorator = Investigation.new(description: text).decorate

      expect(decorator.description).to include "<strong>важное</strong>"
      expect(decorator.description).to include '<a href="http://fbk.info">link</a>'
    end

    it "autolink content" do
      text = 'размещено тут: http://fbk.info (ссылка на блог)'
      decorator = Investigation.new(description: text).decorate

      expect(decorator.description).to include '<a href="http://fbk.info">http://fbk.info</a>'
    end
  end
end
