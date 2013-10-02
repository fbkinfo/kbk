class PhotosController < ApplicationController
  before_filter :authenticate_user!
  skip_before_filter :verify_authenticity_token, only: :create

  respond_to :html

  def create
    @photo = Photo.create!(uploader_params)
    @investigation_id = params[:investigation_id]

    render partial: "investigations/modals/photo_form_block"
  end

  def destroy
    photo = find_photo
    photo.destroy

    if request.xhr?
      render nothing: true
    else
      respond_with photo, location: photo.investigation
    end
  end

  def finalize
    finalize_params.each do |photo|
      model = Photo.find(photo.delete(:id))
      model.update(photo)
    end

    redirect_to :back
  end

  private

  def find_photo
    Photo.find(params[:id])
  end

  def uploader_params
    params.permit(:entry_date, :image, :investigation_id)
  end

  def finalize_params
    params.permit(photo: [:id, :comment, :entry_date, :investigation_id]).require(:photo)
  end
end
