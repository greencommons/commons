module Users
  class ProfileController < ApplicationController
    before_action :authenticate_user!

    def edit
      @user = current_user
    end

    def update
      @user = User.find(current_user.id)

      if skip_password_update?
        user_params = user_password_params.except(:current_password,
                                                  :password,
                                                  :password_confirmation)
      end

      if user_params ? @user.update(user_params) : @user.update_with_password(user_password_params)
        bypass_sign_in(@user)
        redirect_to profile_path, notice: 'Profile updated.'
      else
        render :edit
      end
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
