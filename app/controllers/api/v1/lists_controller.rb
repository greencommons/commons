module Api
  module V1
    class ListsController < ApiController
      skip_before_action :validate_auth_scheme, only: %i(show)
      skip_before_action :authenticate_client, only: %i(show)

      def show
        render_json_api present_entity(List.find(params[:id]))
      end
    end
  end
end
