module Api
  module V1
    class UsersController < ApiController
      include Shared::Users

      skip_before_action :validate_auth_scheme, only: %i(index show)
      skip_before_action :authenticate_client, only: %i(index show)

      def create
        @user = User.new(user_password_params)
        authorize @user

        if @user.save
          render_json_api present_entity(@user)
        else
          render_json_api present_errors(@user, [@user.errors]), status: 400
        end
      end

      def update
        @user = User.find(params[:id])

        shared_update(lambda do
          render_json_api present_entity(@user)
        end, lambda do
          render_json_api present_errors(@user, [@user.errors]), status: 400
        end)
      end

      private

      def user_password_params
        params.require(:data).
          require(:attributes).
          permit(:first_name, :last_name, :email, :bio,
                 :current_password, :password, :password_confirmation)
      end
    end
  end
end
