require 'spec_helper'

describe AttachedDestroyPolicy do
  context "document with many snapshots" do
    it "is allowed to destroy" do
      document = create(:document)
      snapshot = create(:snapshot, document: document)

      policy = described_class.new(snapshot)
      expect(policy.allowed?).to be_true
    end
  end

  context "document with one snapshot" do
    it "is not allowed to destroy" do
      document = create(:document)

      policy = described_class.new(document.snapshots.first)
      expect(policy.allowed?).to be_false
    end
  end

  context "document with one attachement" do
    it "is not allowed to destroy" do
      document = create(:document)
      create(:document_attachement, document: document)
      document.snapshots.destroy_all

      policy = described_class.new(document.attachements.first)

      expect(policy.allowed?).to be_false
    end
  end

  context "document with one snapshot and many attachements" do
    it "is allowed to destroy" do
      document = create(:document)
      create_list(:document_attachement, 2, document: document)

      policy = described_class.new(document.snapshots.first)
      expect(policy.allowed?).to be_true
    end
  end

  context "document with one snapshot and one attachement" do
    it "is allowed to destroy" do
      document = create(:document)
      create(:document_attachement, document: document)

      policy = described_class.new(document.snapshots.first)
      expect(policy.allowed?).to be_true
    end
  end

  context "document is empty" do
    it "is allowed to destroy" do
      snapshot = create(:snapshot)
      policy = described_class.new(snapshot)
      expect(policy.allowed?).to be_true
    end
  end
end
