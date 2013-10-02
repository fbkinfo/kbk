require 'open-uri'
require 'prawn'
require 'prawn/fast_png'
require 'concerns/safe_destroy'
require 'concerns/with_timeline_entry'

class Document < ActiveRecord::Base
  include SafeDestroy

  include WithTimelineEntry

  extend Enumerize

  enumerize :kind, in: [:outgoing, :incoming], default: :outgoing, scope: true, predicates: true
  scope :incoming, -> { with_kind(:incoming) }
  scope :outgoing, -> { with_kind(:outgoing) }

  has_ancestry
  # TODO
  # :cache_depth         Cache the depth of each node in the 'ancestry_depth' column (default: false)
  #                      If you turn depth_caching on for an existing model:
  #                      - Migrate: add_column [table], :ancestry_depth, :integer, :default => 0
  #                      - Build cache: TreeNode.rebuild_depth_cache!

  mount_uploader :pdf, PdfUploader

  belongs_to :response, class_name: 'Document'
  belongs_to :user, counter_cache: true
  belongs_to :author
  belongs_to :investigation
  belongs_to :organization, counter_cache: true

  alias_attribute :cause, :parent
  alias_attribute :cause_id, :parent_id
  alias_attribute :responses, :children

  # Required for `form_for` to work.
  # Fuck you Ancestry...
  def parent_id_before_type_cast
    parent_id
  end

  has_many :snapshots
  has_many :attachements, class_name: 'DocumentAttachement'

  validates :title, presence: true
  validates :description, presence: true
  validates :user, presence: true
  validates :author, presence: true
  validates :investigation, presence: true
  validates :organization, presence: true

  validate :should_contain_snapshot_or_attachement
  validate :cause_in_investigation, if: -> { investigation_id && cause_id }
  validate :cause_is_not_in_subtree, if: -> { cause_id }
  validate :cause_is_earlier_than_self, if: -> { cause_id && document_date }

  scope :latest, -> { order('documents.document_date DESC, documents.id DESC') }
  scope :expired, -> { without_response.outgoing.where('documents.due_date <= ?', Date.current) }
  scope :without_response, -> { where(response_id: nil) }
  scope :with_due_date, -> { where("documents.due_date IS NOT NULL") }

  scope :textual, lambda{|needle|
    needle = "%#{needle}%"
    fields = [
      arel_table[:title],
      arel_table[:description],
      Investigation.arel_table[:title],
      Investigation.arel_table[:description],
      Organization.arel_table[:name],
      Author.arel_table[:name]
    ]

    condition = fields.shift.matches(needle)
    fields.each{|f| condition = condition.or(f.matches needle)}

    includes(:author, :organization, :investigation).where(condition)
  }

  after_create :update_investigation_caches
  after_save   :update_organization_caches
  after_save   :refresh_response

  def responded?
    response.present?
  end

  def caused?
    cause_id.present?
  end

  def overdue?
    return false if due_date.blank?
    due_date < Date.current
  end

  def overtime
    (DateTime.now - due_date.to_datetime).to_i
  end

  def possible_causes
    if investigation
      causes = investigation.documents
      causes = causes.where(["documents.id NOT IN (?)", subtree_ids]) unless new_record?
      causes.where(["documents.document_date IS NULL OR documents.document_date <= ?", document_date]) if document_date
      causes
    else
      Document.none
    end
  end

  def published?
    investigation.publish.active? && investigation.published_until >= document_date
  end

  # two methods for timeline
  def entry_date
    document_date || created_at
  end

  def entry_date_changed?
    document_date_changed?
  end

  private

  def update_investigation_caches
    investigation.cache_latest_document!
  end

  def update_organization_caches
    organization.cache_investigations_counter!
  end

  def refresh_response
    if parent && parent.response_id.blank?
      parent.update_attribute(:response_id, id)
    end

    p = Document.new(ancestry: ancestry_was).parent
    if ancestry_was && p.response_id == id
      p.update_attribute(:response_id, p.responses.first.try(:id))
    end
  end

  def possible_cause_ids
    new_record
  end

  def should_contain_snapshot_or_attachement
    if snapshots.empty? && attachements.empty?
      errors.add(:base, :no_snapshot_or_attachement)
    end
  end

  def cause_in_investigation
    errors.add(:cause_id, :not_in_investigation) unless investigation.documents.exists?(cause_id)
  end

  def cause_is_not_in_subtree
    errors.add(:cause_id, :cause_exists_in_subtree) if (!new_record? && subtree_ids.include?(cause_id))
  end

  def cause_is_earlier_than_self
    errors.add(:document_date, :document_dated_before_cause) if (cause.document_date && cause.document_date > self.document_date)
  end
end
