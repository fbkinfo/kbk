class TimelineEntry < ActiveRecord::Base
  belongs_to :investigation

  belongs_to :resource, polymorphic: true

  validates :resource, :investigation, :entry_date, presence: true

  scope :latest, -> { order("entry_date DESC") }

  def self.create_from_resource(model)
    create!(
      resource: model,
      entry_date: model.entry_date,
      investigation: model.investigation
    )
  end
end
