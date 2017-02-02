class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show]

  def show
    @suggestions = Suggesters::Tags.new(tags: @resource.tag_list,
                                        except: @resource,
                                        limit: 6).suggest
  end

  private

  def set_resource
    @resource = Resource.find(params[:id])
    authorize @resource
  end
end
