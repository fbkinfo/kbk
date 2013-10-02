require 'concerns/with_timeline_entry'

class Link < ActiveRecord::Base
  include WithTimelineEntry

  belongs_to :investigation

  validates :title, :investigation, :url, presence: true

  before_validation :prepare_url

  private

  def prepare_url
    return if url.blank?

    unless url =~ /^(http|https):\/\//
      self.url = "http://#{url}"
    end
  end
end
