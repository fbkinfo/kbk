class AttachedDestroyPolicy
  def initialize(model)
    @document = model.document
  end

  def allowed?
    return true if @document.nil?

    (snapshots_count >= 1 && attachements_count >= 1) ||
    (snapshots_count == 0 && attachements_count > 1) ||
    (snapshots_count > 1 && attachements_count == 0)
  end

  def snapshots_count
    @snapshots_count ||= @document.snapshots.count
  end

  def attachements_count
    @attachements_count ||= @document.attachements.count
  end
end
