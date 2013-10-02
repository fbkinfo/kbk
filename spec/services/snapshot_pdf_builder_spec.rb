require 'spec_helper'
require 'pdf-reader'

describe SnapshotPdfBuilder do
  before do
    ScanUploader.enable_processing = true
  end

  after do
    ScanUploader.enable_processing = false
  end

  it "converts snapshots to pdf" do
    snapshots = create_list(:snapshot, 2)
    builder = described_class.new(snapshots)
    result = builder.render

    begin
      file = Tempfile.new('pdf')
      File.open(file.path, 'wb') { |f| f << result }

      reader = PDF::Reader.new(file.path)
      expect(reader.page_count).to eq snapshots.size
    ensure
      file.close
      file.unlink
    end
  end
end
