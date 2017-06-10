module Api
  module V1
    class ResourcesController < ApiController
      skip_before_action :validate_auth_scheme, only: %i(show)
      skip_before_action :authenticate_client, only: %i(show)
      before_action :set_resource, only: %i(show update)

      def show
        render_json_api present_entity(@resource)
      end

      def create
        @resource = Resource.new(resource_params)
        authorize @resource

        @resource.resource_type = :url
        @resource.user = current_user

        if @resource.save
          render_json_api present_entity(@resource)
        else
          render_json_api present_errors(@resource, [@resource.errors]), status: 400
        end
      end

      def update
        if @resource.update(resource_params)
          render_json_api present_entity(@resource)
        else
          render_json_api present_errors(@resource, [@resource.errors]), status: 400
        end
      end

      private

      def set_resource
        @resource = Resource.find(params[:id])
        authorize @resource
      end

      def resource_params
        params.require(:data).
          require(:attributes).
          permit(:title, :url)
      end
    end
  end
end
