require 'concerns/safe_destroy'

class Investigation < ActiveRecord::Base
  include SafeDestroy

  extend Enumerize

  enumerize :status, in: [:active, :success, :failure], default: :active, scope: true, predicates: true

  enumerize :project_kind, in: [:rospil, :investigation], default: :investigation

  validates :title, presence: true, uniqueness: true
  validates :user, presence: true

  belongs_to :user
  belongs_to :latest_document, class_name: 'Document'

  has_many :documents

  has_many :videos, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :links, dependent: :destroy

  has_many :organizations, -> { uniq }, through: :documents
  has_many :timeline_entries, dependent: :destroy

  scope :published, -> { where("published_until IS NOT NULL") }
  scope :textual, lambda{|needle|
    needle = "%#{needle}%"
    fields = [
      arel_table[:title],
      arel_table[:description],
      Document.arel_table[:title],
      Document.arel_table[:description],
      Organization.arel_table[:name]
    ]

    condition = fields.shift.matches(needle)
    fields.each{|f| condition = condition.or(f.matches needle)}

    includes(:latest_document, :organizations).where(condition)
  }

  def publish
    @publish ||= InvestigationPublish.new(self)
  end

  def cache_latest_document!
    update_attribute(:latest_document, documents.latest.first)
  end
end
