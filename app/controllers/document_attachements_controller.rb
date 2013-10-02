class DocumentAttachementsController < ApplicationController
  respond_to :html

  skip_before_filter :verify_authenticity_token, only: :create

  def create
    attachement = if params[:document_id]
      document = Document.find(params[:document_id])
      document.attachements.create(upload_params)
    else
      DocumentAttachement.create(upload_params)
    end

    render partial: 'documents/attachement', object: attachement
  end

  def destroy
    attachement = DocumentAttachement.find(params[:id])
    attachement.destroy

    render nothing: true
  end

  private

  def upload_params
    params.permit(:file)
  end
end
