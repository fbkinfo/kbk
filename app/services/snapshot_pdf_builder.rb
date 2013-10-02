class SnapshotPdfBuilder
  def initialize(pages)
    @pages = pages
  end

  def render
    prawn = Prawn::Document.new(
      margin: 0,
      page_size: [@pages.first.original_scan_width, @pages.first.original_scan_height]
    )

    @pages.each_with_index do |s, i|
      prawn.start_new_page(size: [s.original_scan_width, s.original_scan_height]) unless i == 0
      prawn.image s.original_scan.file
    end

    prawn.render
  end
end
