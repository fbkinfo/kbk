class SnapshotProcessor
  DENSITY = 150

  attr_reader :upload, :original_filename

  def initialize(upload)
    @upload = upload
    @original_filename = upload.original_filename
  end

  def process!
    snapshots = []

    write!

    if multipage?
      il = Magick::ImageList.new(@filename) { self.density = DENSITY }
      il.each_with_index do |img, index|
        filename = write_snapshot_page!(img, index)
        snapshots << Snapshot.new(original_scan: File.new(filename))
      end
    else
      snapshots << Snapshot.new(original_scan: @upload)
    end

    snapshots
  end

  def multipage?
    @upload.content_type.include?('pdf')
  end

  private

  def write!
    @filename = Tempfile.new(original_filename).path
    File.open(@filename, 'wb') { |f| f.write(@upload.read) }
  end

  def write_snapshot_page!(img, index)
    filename = Tempfile.new(["#{original_filename}-#{index}--", ".jpg"]).path
    img.write(filename) { self.quality = 90 }

    filename
  end
end
