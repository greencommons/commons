module Users
  class ProfileController < ApplicationController
    include Shared::Users

    before_action :authenticate_user!

    def edit
      @user = current_user
    end

    def update
      shared_update(lambda do
        bypass_sign_in(@user)
        redirect_to profile_path, notice: 'Profile updated.'
      end, lambda do
        render :edit
      end)
    end

    private

    def skip_password_update?
      user_password_params[:current_password].blank? &&
        user_password_params[:password].blank? &&
        user_password_params[:password_confirmation].blank?
    end

    def user_password_params
      params.require(:user).permit(:first_name, :last_name, :email, :bio, :avatar,
                                   :current_password, :password,
                                   :password_confirmation)
    end
  end
end
