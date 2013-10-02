module WithTimelineEntry
  extend ActiveSupport::Concern

  included do
    after_create  :add_timeline_entry
    after_destroy :clear_timeline_entry
    after_update  :update_timeline_entry
  end

  def timeline_entry
    TimelineEntry.where(resource_type: self.class.name, resource_id: id).first
  end

  private

  def clear_timeline_entry
    timeline_entry.try(:destroy)
  end

  def add_timeline_entry
    if investigation.present? && entry_date.present?
      TimelineEntry.create_from_resource(self)
    end
  end

  def update_timeline_entry
    if timeline_entry.nil?
      add_timeline_entry
    elsif entry_date_changed?
      timeline_entry.update_column(:entry_date, entry_date)
    end
  end
end
