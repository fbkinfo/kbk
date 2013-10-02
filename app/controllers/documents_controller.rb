class DocumentsController < ApplicationController

  before_filter :authenticate_user!, except: :show
  before_filter :set_collections, only: :index
  before_filter :load_and_check_permissions, only: :show

  respond_to :html

  def index
    @filter = DocumentsFilter.new(params[:f], @favourite_ids)
    @sorter = DocumentsSorter.new(params[:s])

    @documents = @sorter.apply(@filter.apply).page(params[:page])

    render layout: 'index'
  end

  def new
    @document_form = DocumentForm.new(user: current_user)
    @document_form.populate(params)
  end

  def create
    @document_form = DocumentForm.new(user: current_user)
    @document_form.attributes = document_params
    @document_form.save

    log_validation(@document_form)

    respond_with @document_form
  end

  def edit
    @document_form = DocumentForm.new(find_document)
  end

  def update
    @document_form = DocumentForm.new(find_document)
    @document_form.attributes = document_params
    @document_form.save

    log_validation(@document_form)

    respond_with @document_form
  end

  def show
    @snapshots = SnapshotDecorator.decorate_collection(@document.snapshots.sorted)

    respond_to do |format|
      format.html
      if user_signed_in?
        format.pdf { redirect_to @document.pdf.prepared_url }
      end
    end
  end

  def destroy
    document = find_document

    if !document.responded? && (document.user == current_user || current_user.admin?)
      document.safe_destroy
    end

    redirect_to :documents
  end

  private

  def set_collections
    @favourite_ids  = current_user.favourites.documents.pluck(:entry_id)
    @investigations = Investigation.all.pluck(:title, :id)
    @authors        = Author.all.pluck(:name, :id)
    @organizations  = Organization.all.pluck(:name, :id)
  end

  def find_document
    Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(:title, :description, :investigation_id, :user_id, :organization_id, :document_date, :due_date, :ancestry, :cause_id, :author_id, :kind, :final, :renew_investigation_publish, snapshot_ids: [], attachement_ids: [])
  end

  def load_and_check_permissions
    @document = find_document

    unless @document.published? || user_signed_in?
      redirect_to new_user_session_path
    end
  end

  def log_validation(document)
    return if document.errors.blank?

    begin
      logger = Logger.new(Rails.root.join("log/validation.log"))
      logger.info "documents: #{current_user.id}##{current_user.email}: #{document.errors.inspect}"
    ensure
      logger.close
    end
  end
end
