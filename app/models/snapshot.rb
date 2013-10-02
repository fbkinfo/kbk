class Snapshot < ActiveRecord::Base
  belongs_to :document
  mount_uploader :original_scan, ScanUploader
  mount_uploader :public_scan, ScanUploader

  validates :number, presence: true
  validates :original_scan, presence: true

  before_validation :set_number, on: :create
  after_save :remove_document_pdf
  after_destroy :remove_document_pdf

  scope :sorted, -> { order(:number) }

  def self.user_sort(user_order)
    transaction do
      user_order.each_with_index do |id, number|
        where(id: id).update_all(number: number + 1)
      end

      document = find(user_order.last).document
      document.remove_pdf = true
      document.save!
    end
  end

  def self.cleanup
    where(document_id: nil).where("created_at < ?", 2.days.ago).destroy_all
  end

  private

  def set_number
    self.number = last_document_number + 1
  end

  def last_document_number
    self.class.where(document_id: document_id).maximum(:number) || 0
  end

  def remove_document_pdf
    return if document.blank?

    document.remove_pdf = true
    document.save!
  end
end
