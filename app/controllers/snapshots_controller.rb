require 'carrierwave_string_io'

class SnapshotsController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token, only: :create

  respond_to :json, only: :update

  def sort
    Snapshot.user_sort(params[:snapshot])

    render nothing: true
  end

  def destroy
    snapshot = Snapshot.find(params[:id])

    policy = AttachedDestroyPolicy.new(snapshot)

    if policy.allowed?
      snapshot.destroy
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def create
    sp = SnapshotProcessor.new(params[:file])
    snapshots = sp.process!

    if params[:document_id]
      @document = Document.find(params[:document_id])
      @document.snapshots << snapshots
    else
      snapshots.each(&:save!)
    end

    render partial: 'documents/snapshot', collection: snapshots
  end

  def update
    snapshot = Snapshot.find(params[:id])
    snapshot.update(snapshot_params)

    raise snapshot.errors.inspect unless snapshot.valid?

    respond_with snapshot
  end

  private

  def snapshot_params
    {
      public_scan: CarrierwaveStringIO.new(params[:snapshot][:public_scan])
    }
  end
end
