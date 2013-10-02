module FileFixtures

  def self.photo_path
    images = %w(page1 page2)
    Rails.root.join("spec/fixtures/#{images.sample}.jpg")
  end

  def self.photo
    File.open(photo_path)
  end

  def self.pdf_path
    Rails.root.join("spec/fixtures/example.pdf")
  end

  def self.pdf
    File.open(pdf_path)
  end

end
