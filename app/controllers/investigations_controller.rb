class InvestigationsController < ApplicationController

  before_filter :authenticate_user!, except: [:show, :index]
  before_filter :load_and_check_permissions, only: :show

  respond_to :html

  def index
    if user_signed_in?
      index_for_authorized
    else
      index_for_anonymous
    end

    render layout: 'index'
  end

  def edit
    @investigation = find_investigation
  end

  def new
    @investigation = Investigation.new
  end

  def show
    @investigation = find_investigation.decorate

    @documents = @investigation.documents.latest
    @timeline_entries = @investigation.timeline_entries.latest

    if !user_signed_in?
      @documents = @documents.where("document_date <= ?", @investigation.published_until)
      @timeline_entries = @timeline_entries.where("entry_date <= ?", @investigation.published_until)
    end

    respond_to do |format|
      format.html
      if user_signed_in?
        format.json { render json: @investigation.as_json(include: { documents: { only: [:id, :title] } }, root: false) }
      end
    end
  end

  def publish
    investigation = find_investigation
    flash[:notice] = if investigation.publish.update(params[:date])
      "Расследование опубликовано"
    else
      "Расследование не опубликовано"
    end

    redirect_to investigation
  end

  def unpublish
    investigation = find_investigation
    investigation.publish.cancel

    redirect_to investigation, notice: "Расследование скрыто"
  end

  def update
    @investigation = find_investigation
    @investigation.update(investination_params)

    respond_with @investigation
  end

  def create
    @investigation = current_user.investigations.create(investination_params)
    respond_with @investigation
  end

  def destroy
    investigation = find_investigation
    if investigation.user == current_user || current_user.admin?
      investigation.safe_destroy
    end

    redirect_to :investigations
  end

  private

  def set_collections
    @favourite_ids = current_user.favourites.investigations.pluck(:entry_id)
    @organizations = Organization.all.pluck(:name, :id)
    @users = User.all.pluck(:name, :id)
  end

  def investination_params
    params.require(:investigation).permit(:description, :title, :organization_id, :user_id, :status)
  end

  def find_investigation
    Investigation.find(params[:id])
  end

  def load_and_check_permissions
    @investigation = find_investigation
    if !user_signed_in? && @investigation.published_until.blank?
      redirect_to new_user_session_path
    end
  end

  def index_for_authorized
    set_collections

    @filter = InvestigationsFilter.new(params[:f], current_user, @favourite_ids)
    @sorter = InvestigationsSorter.new(params[:s])
    @investigations = @sorter.apply(@filter.apply)

    @investigations = @investigations.page(params[:page])
  end

  def index_for_anonymous
    @investigations = Investigation.published.page(params[:page])
  end
end
