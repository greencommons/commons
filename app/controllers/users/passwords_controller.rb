module Users
  class PasswordsController < ApplicationController
    before_action :authenticate_user!

    def edit
      @user = current_user
    end

    def update
      @user = User.find(current_user.id)

      if @user.update_with_password(password_params)
        bypass_sign_in(@user)
        redirect_to profile_path, notice: 'Password updated.'
      else
        render :edit
      end
    end

    private

    def password_params
      params.require(:user).permit(:current_password, :password, :password_confirmation)
    end
  end
end
