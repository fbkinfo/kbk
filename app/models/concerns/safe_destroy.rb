module SafeDestroy
  extend ActiveSupport::Concern

  included do
    scope :not_deleted, -> { where("#{table_name}.deleted_at IS NULL") }
    scope :deleted,     -> { where("#{table_name}.deleted_at IS NOT NULL") }

    default_scope -> { not_deleted }
  end

  def safe_destroy
    update_column(:deleted_at, Time.current)
    destroy_timeline_entry
  end

  def deleted?
    deleted_at?
  end

  private

  def destroy_timeline_entry
    if respond_to?(:timeline_entry)
      timeline_entry.destroy
    end
  end
end
