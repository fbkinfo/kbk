require 'spec_helper'

describe DocumentForm do
  describe "being populated" do
    it "document_date contains current date" do
      form = DocumentForm.new
      form.populate({})

      expect(form.document_date).to eq(Date.current)
    end

    it "investigation contains relation" do
      investigation = create(:investigation)
      form = DocumentForm.new
      form.populate(investigation_id: investigation.id)

      expect(form.investigation).to eq(investigation)
    end

    context "being answered" do
      it "cause contains relation" do
        document = create(:document)
        form = DocumentForm.new
        form.populate(cause_id: document.id)

        expect(form.cause).to eq(document)
        expect(form.investigation).to eq(document.investigation)
      end

      it "answer kind is outgoing" do
        document = create(:document, kind: :outgoing)
        form = DocumentForm.new
        form.populate(cause_id: document.id)

        expect(form.kind).to eq "incoming"
      end
    end
  end

  it "provides list of organizations" do
    org = create(:organization, name: "evl.ms")
    form = DocumentForm.new
    expect(form.organizations_list).to eq([["evl.ms", org.id]])
  end

  it "provides list of authors" do
    author = create(:author, name: "Vladi")
    form = DocumentForm.new
    expect(form.authors_list).to eq([["Vladi", author.id]])
  end

  it "provides list of investigations" do
    investigation = create(:investigation, title: "Yakunin")
    form = DocumentForm.new
    expect(form.investigations_list).to eq([["Yakunin", investigation.id]])
  end

  it "sets author with initializer" do
    user = create(:user)
    form = DocumentForm.new(user: user)

    expect(form.user).to eq(user)
    expect(form.author).to eq(user.author)
  end

  describe "relation attributes are being normalized" do
    it "creates new records if titles provided" do
      user = create(:user)

      form = DocumentForm.new(user: user)
      form.attributes = {
        organization_id: "New org",
        investigation_id: "New invest",
        author_id: "A. Navalny"
      }

      expect(form.organization.persisted?).to be_true
      expect(form.organization.name).to eq "New org"

      expect(form.author.persisted?).to be_true
      expect(form.author.name).to eq "A. Navalny"

      expect(form.investigation.persisted?).to be_true
      expect(form.investigation.title).to eq "New invest"
    end

    it "uses existing records if ids provided" do
      organization = create(:organization)
      author = create(:author)
      investigation = create(:investigation)

      form = DocumentForm.new
      form.organization_id = organization.id
      form.investigation_id = investigation.id
      form.author_id = author.id

      expect(form.organization.persisted?).to be_true
      expect(form.organization).to eq organization

      expect(form.author.persisted?).to be_true
      expect(form.author).to eq author

      expect(form.investigation.persisted?).to be_true
      expect(form.investigation).to eq investigation
    end
  end

  describe "#save" do
    it "saves record" do
      document = Document.new
      form = DocumentForm.new(document)

      expect(document).to receive(:save)

      form.save
    end

    it "updates investigation published_until attribute" do
      snapshot = create(:snapshot)
      investigation = create(:investigation, published_until: 2.days.ago)

      form = DocumentForm.new(user: create(:user))
      form.attributes = attributes_for(:document, investigation: investigation, snapshot_ids: [snapshot.id]).merge({ renew_investigation_publish: true })
      form.organization = create(:organization)

      expect(form.save).to be_true
      expect(investigation.reload.published_until).to eq form.document_date
    end
  end

  describe "#attributes" do
    it "has virtual and model attributes" do
      form = DocumentForm.new(user: create(:user))
      model_attributes = attributes_for(:document, title: "my title")
      virtual_attributes = { renew_investigation_publish: true }
      form.attributes = model_attributes.merge(virtual_attributes)

      result = form.attributes
      expect(form.attributes).to include("title" => model_attributes[:title])
      expect(form.attributes).to include(virtual_attributes)
    end
  end
end
