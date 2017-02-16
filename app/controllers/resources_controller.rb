class ResourcesController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  before_action :set_resource, only: [:show]

  def show
    @suggestions = Suggesters::Tags.new(tags: @resource.cached_tags,
                                        except: @resource,
                                        limit: 6).suggest
  end

  def new
    @resource = Resource.new
    authorize @resource
  end

  def create
    @resource = Resource.new(resource_params)
    authorize @resource

    if @resource.save
      redirect_to @resource, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  private

  def set_resource
    @resource = Resource.find(params[:id])
    authorize @resource
  end

  def resource_params
    params.require(:resource).permit(:title)
  end
end
