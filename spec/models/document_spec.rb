require 'spec_helper'

describe Document do
  describe "being validated" do
    it "requires at least one snapshot or attachement" do
      error_text = I18n.t("activerecord.errors.models.document.no_snapshot_or_attachement")

      document = Document.new
      document.valid?

      expect(document.errors[:base]).to include error_text

      document.snapshots << Snapshot.new
      document.valid?

      expect(document.errors[:base]).not_to include error_text

      document.snapshots = []
      document.attachements << DocumentAttachement.new
      document.valid?
      expect(document.errors[:base]).not_to include error_text
    end
  end

  describe "with related objects" do
    it "updates investigation latest document" do
      document = create(:document)
      expect(document.investigation.latest_document).to eq document
    end

    it "updates response in parent doc" do
      parent = create(:document)
      document = create(:document, parent: parent, organization: parent.organization, investigation: parent.investigation)

      expect(parent.reload.response).to eq(document)
    end
  end

  describe "#overdue?" do
    let(:document) { document = Document.new }

    it "returns true for yesterday" do
      document.due_date = Date.yesterday
      expect(document.overdue?).to be_true
    end

    it "returns false for blank" do
      expect(document.overdue?).to be_false
    end

    it "returns false for tomorrow" do
      document.due_date = Date.tomorrow
      expect(document.overdue?).to be_false
    end
  end

  describe "#published?" do
    context "when investigation published yesterday" do
      it "document with yesterday date is published" do
        investigation = Investigation.new(published_until: Date.yesterday)
        document = Document.new(investigation: investigation, document_date: Date.yesterday)
        expect(document.published?).to be_true
      end

      it "document with current date is not published" do
        investigation = Investigation.new(published_until: Date.yesterday)
        document = Document.new(investigation: investigation, document_date: Date.current)
        expect(document.published?).to be_false
      end
    end

    context "when investigation is not published" do
      it "document is not published" do
        investigation = Investigation.new
        document = Document.new(investigation: investigation)
        expect(document.published?).to be_false
      end
    end
  end
end
