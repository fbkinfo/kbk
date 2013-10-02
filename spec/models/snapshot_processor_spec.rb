require 'spec_helper'

describe SnapshotProcessor do
  before do
    ScanUploader.enable_processing = true
  end

  after do
    ScanUploader.enable_processing = false
  end

  # not working on travis because of old imagemagick deb package
  context "with pdf files", pending: !!ENV["TRAVIS"] do
    it "can process pdf to snapshot pages" do
      pdf = Rack::Test::UploadedFile.new(FileFixtures.pdf_path, "application/pdf")
      processor = described_class.new(pdf)

      snapshots = processor.process!

      expect(snapshots.size).to eq 2

      snapshots.each do |snap|
        expect(snap).to be_new_record
        expect(snap.original_scan).to be_present
        expect(snap.original_scan_width).to be > 0
        expect(snap.original_scan_height).to be > 0
      end
    end
  end

  context "with jpeg" do
    it "can process jpeg to snapshot page" do
      jpeg = Rack::Test::UploadedFile.new(FileFixtures.photo_path, "image/jpeg")
      processor = described_class.new(jpeg)

      result = processor.process!

      expect(result.size).to eq 1
      expect(result[0]).to be_new_record
      expect(result[0].original_scan).to be_present
      expect(result[0].original_scan_width).to be > 0
      expect(result[0].original_scan_height).to be > 0
    end
  end
end
