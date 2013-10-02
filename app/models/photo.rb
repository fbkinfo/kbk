require 'concerns/with_timeline_entry'

class Photo < ActiveRecord::Base
  include WithTimelineEntry

  belongs_to :investigation

  validates :image, presence: true

  mount_uploader :image, PhotoUploader

  def self.cleanup
    where(investigation_id: nil).where("created_at < ?", 2.days.ago).destroy_all
  end
end
