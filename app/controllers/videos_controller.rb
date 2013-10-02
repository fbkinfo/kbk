class VideosController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html

  def create
    video = Video.create(video_params)

    respond_with video, location: video.investigation
  end

  def destroy
    video = find_video
    video.destroy

    respond_with video, location: video.investigation
  end

  private

  def find_video
    Video.find(params[:id])
  end

  def video_params
    params.require(:video).permit(:entry_date, :body, :investigation_id)
  end

end
