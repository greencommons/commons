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
    @resource = Resource.new(resource_type: :url)
    authorize @resource
    load_resource_types
  end

  def edit
    load_resource_types
  end

  def create
    @resource = Resource.new(resource_params_for_create)
    @resource.assign_attributes(user: current_user, user_input: true)
    authorize @resource

    if @resource.save
      redirect_to edit_resource_path(@resource), notice: resource_created_message
    else
      load_resource_types
      render :new
    end
  end

  def update
    @resource.assign_attributes(user_input: true)
    if @resource.update(resource_params_for_update)
      redirect_to @resource, notice: 'Resource was successfully updated.'
    else
      load_resource_types
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

  def resource_params_for_create
    params.require(:resource).
      permit(:title, :url, :resource_type, :short_content, :privacy, :content_download_link)
  end

  def resource_params_for_update
    params.require(:resource).
      permit(:title, :resource_type, :short_content, :privacy, :creators,
             :publisher, :date, :publisher, :rights, :pages, :isbn, :tag_list)
  end

  def load_resource_types
    @resource_types = (Resource::RESOURCE_TYPES.keys - %w(audio video image url)).sort
  end

  def resource_created_message
    'Your resource has been created! Now,'\
    " add some metadata, or go straight to the #{link_to_resource}."
  end

  def link_to_resource
    "<a href=\"#{resource_path(@resource)}\">resource page</a>"
  end
end
