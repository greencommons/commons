class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show]

  def show
  end

  private

  def set_resource
    @resource = Resource.find(params[:id])
    authorize @resource
  end
end
