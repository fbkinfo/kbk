class OrganizationsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @sorter = OrganizationsSorter.new(params[:s])
    @organizations = @sorter.apply(Organization.all).page(params[:page])

    render layout: 'index'
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.create(organizations_params)
    respond_with @organization, location: :organizations
  end

  def edit
    @organization = find_organization
  end

  def update
    @organization = find_organization
    @organization.update(organizations_params)

    respond_with @organization, location: :organizations
  end

  private

  def organizations_params
    params.require(:organization).permit(:name)
  end

  def find_organization
    Organization.find(params[:id])
  end
end
