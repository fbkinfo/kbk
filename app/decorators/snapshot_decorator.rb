class SnapshotDecorator < Draper::Decorator
  delegate_all

  def scan
    if !h.user_signed_in? && object.public_scan.present?
      object.public_scan
    else
      object.original_scan
    end
  end

end
