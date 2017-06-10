module Shared
  module Users
    def shared_update(success, failure)
      @user = User.find(current_user.id)
      authorize @user

      if skip_password_update?
        user_params = user_password_params.except(:current_password,
                                                  :password,
                                                  :password_confirmation)
      end

      if user_params ? @user.update(user_params) : @user.update_with_password(user_password_params)
        success.call
      else
        failure.call
      end
    end

    private

    def skip_password_update?
      user_password_params[:current_password].blank? &&
        user_password_params[:password].blank? &&
        user_password_params[:password_confirmation].blank?
    end
  end
end
