class ApiKeysController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.api_keys.create unless current_user.api_keys.enabled.any?
    redirect_to '/profile'
  end

  private

end
