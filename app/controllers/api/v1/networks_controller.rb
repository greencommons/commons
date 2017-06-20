module Api
  module V1
    class NetworksController < ApiController
      skip_before_action :validate_auth_scheme, only: %i(index show)
      skip_before_action :authenticate_client, only: %i(index show)

      def index
        data, = search(models: [Network])
        render_json_api data
      end

      def show
        render_json_api present_entity(Network.find(params[:id]))
      end

      def create
        @network = Network.new(network_params)
        authorize @network

        if @network.save
          @network.touch
          @network.add_admin(current_user)
          render_json_api present_entity(@network)
        else
          render_json_api present_errors(@network, [@network.errors]), status: 400
        end
      end

      def update
        @network = Network.find(params[:id])
        authorize @network

        if @network.update(network_params)
          @network.touch
          render_json_api present_entity(@network)
        else
          render_json_api present_errors(@network, [@network.errors]), status: 400
        end
      end

      private

      def network_params
        params.require(:data).
          require(:attributes).
          permit(:name, :short_description, :long_description,
                 :tag_list, :url, :email)
      end
    end
  end
end
