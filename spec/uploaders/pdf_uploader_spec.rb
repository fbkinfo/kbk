require 'spec_helper'

describe PdfUploader do
  let(:fixture_pdf_path) { FileFixtures.pdf_path }

  it "generates pdf on request" do
    model = create(:document)

    SnapshotPdfBuilder.any_instance.stub(:render) {
      File.open(fixture_pdf_path).read
    }

    expect(model[:pdf]).to be_nil
    uploader = described_class.new(model)

    generated = uploader.prepared_url
    generated_path = "#{Rails.root.join("public")}#{generated}"

    identical = FileUtils.compare_file(generated_path, fixture_pdf_path)
    expect(identical).to be_true

    expect(model[:pdf]).to be_present
  end
end