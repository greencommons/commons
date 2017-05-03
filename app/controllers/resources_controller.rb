class ResourcesController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_resource, only: [:show, :edit, :update, :destroy, :leave]

  def index
    @resources = policy_scope(Resource).page(params[:page] || 1).per(10)
  end

  def show
    @suggestions = Suggesters::Tags.new(tags: @resource.cached_tags,
                                        except: @resource,
                                        limit: 12).suggest
  end

  def new
    @resource = Resource.new
    authorize @resource
  end

  def edit
  end

  def create
    @resource = Resource.new(resource_params)
    authorize @resource

    @resource.resource_type = :url
    @resource.user = current_user

    if @resource.save
      redirect_to @resource, notice: 'Resource was successfully created.'
    else
      render :new
    end
  end

  def update
    if @resource.update(resource_params)
      redirect_to @resource, notice: 'Resource was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @resource.destroy
    redirect_to resources_url, notice: 'Resource was successfully destroyed.'
  end

  private

  def set_resource
    @resource = Resource.find(params[:id])
    authorize @resource
  end

  def resource_params
    params.require(:resource).permit(:title, :url)
  end
end
