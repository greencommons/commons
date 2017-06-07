module Api
  module V1
    class ResourcesController < ApiController
      skip_before_action :validate_auth_scheme, only: [:show]
      skip_before_action :authenticate_client, only: [:show]

      def show
        render_json_api present_entity(Resource.find(params[:id]))
      end
    end
  end
end
