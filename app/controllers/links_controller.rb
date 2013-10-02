class LinksController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html

  def create
    link = Link.create!(link_params)

    respond_with link, location: link.investigation
  end

  def destroy
    link = find_link
    link.destroy

    respond_with link, location: link.investigation
  end

  private

  def find_link
    Link.find(params[:id])
  end

  def link_params
    params.require(:link).permit(:entry_date, :comment, :investigation_id, :title, :url)
  end
end
