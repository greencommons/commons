class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show]

  def show
    # TODO: Switch this to suggestion mechanism once implemented
    @suggestions = Group.limit(6)
  end

  private

  def set_resource
    @resource = Resource.find(params[:id])
    authorize @resource
  end
end
