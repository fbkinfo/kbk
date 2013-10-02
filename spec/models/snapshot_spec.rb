require 'spec_helper'

describe Snapshot do
  it "iterates number on create" do
    document = create(:document)
    expect(document.snapshots.first.number).to eq(1)

    snapshot = create(:snapshot, document: document)
    expect(snapshot.number).to eq(2)
  end

  it "dont't iterate number on update" do
    document = create(:document)
    snapshot = document.snapshots.first
    expect(snapshot.number).to eq(1)

    expect {
      snapshot.update(public_scan: "porn.jpeg")
    }.not_to change(snapshot, :number)
  end

  it "deletes document pdf on save" do
    SnapshotPdfBuilder.any_instance.stub(:render).and_return(FileFixtures.pdf.read)

    document = create(:document)
    document.pdf.prepared_url
    expect(document.pdf).to be_present

    create(:snapshot, document: document)

    expect(document.pdf).to be_blank
  end

  it "can cleanup old records" do
    snapshot = create(:snapshot, document_id: nil, created_at: 3.weeks.ago)
    described_class.cleanup

    expect(described_class.exists?(id: snapshot.id)).to be_false
  end
end
