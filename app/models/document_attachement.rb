class DocumentAttachement < ActiveRecord::Base
  belongs_to :document
  validates :file, presence: true

  mount_uploader :file, AttachementUploader

  def filename
    File.basename(file.path)
  end
end
