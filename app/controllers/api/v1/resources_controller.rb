module Api
  module V1
    class ResourcesController < ApiController
      def show
        @resource = Resource.find(params[:id])
        render json: @resource
      end
    end
  end
end
