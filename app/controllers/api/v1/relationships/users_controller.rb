module Api
  module V1
    module Relationships
      class UsersController < ApiController
        skip_before_action :validate_auth_scheme, only: %i(index)
        skip_before_action :authenticate_client, only: %i(index)

        before_action :set_network

        def index
          results = @network.networks_users.includes(:user).
                    page(params[:page] || 1).per(params[:per] || 10)
          render_json_api present_collection(results, @network.networks_users.count)
        end

        def create
          authorize @network, :update?
          users = User.where(id: params[:data].map { |d| d[:id] })

          users.each do |user|
            @network.add_user(user) unless @network.find_member(user)
          end

          results = @network.networks_users.includes(:user).
                    page(params[:page] || 1).per(params[:per] || 10)
          render_json_api present_collection(results, @network.networks_users.count)
        end

        def update
          render_json_api_error({
                                  title: 'Forbidden',
                                  message: 'Complete replacement is not allowed for this resource.'
                                }, 403)
        end

        def destroy
          authorize @network, :update?
          users = User.where(id: params[:data].map { |d| d[:id] })
          users.each { |user| @network.find_member(user).try(:destroy) }

          results = @network.networks_users.includes(:user).
                    page(params[:page] || 1).per(params[:per] || 10)
          render_json_api present_collection(results, @network.networks_users.count)
        end

        private

        def set_network
          @network = Network.find(params[:network_id])
        end
      end
    end
  end
end
