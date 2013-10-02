class FavouritesController < ApplicationController
  before_filter :authenticate_user!

  def create
    user_favoutires = UserFavourites.new(current_user)
    user_favoutires.add(resource)
    render nothing: true
  end

  def destroy
    user_favoutires = UserFavourites.new(current_user)
    user_favoutires.remove(resource)
    render nothing: true
  end

  private

  def resource
    if params[:investigation_id]
      Investigation.find(params[:investigation_id])
    elsif params[:document_id]
      Document.find(params[:document_id])
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

end
