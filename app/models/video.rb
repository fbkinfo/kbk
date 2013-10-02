require 'concerns/with_timeline_entry'

class Video < ActiveRecord::Base
  include WithTimelineEntry

  belongs_to :investigation

  validates :investigation, :entry_date, :body, presence: true
end
