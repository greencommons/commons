module Users
  class ProfileController < ApplicationController
    before_action :authenticate_user!

    def edit
      @user = current_user
    end

    def update
      @user = User.find(current_user.id)

      if @user.update(users_params)
        redirect_to profile_path, notice: 'Profile updated.'
      else
        render :edit
      end
    end

    private

    def users_params
      params.require(:user).permit(:first_name, :last_name, :email, :bio)
    end
  end
end
