module Api
  class AutocompleteController < ApplicationController
    before_action :authenticate_user!

    def members
      users = UserFilter.new(query: params[:q], group_id: params[:group_id]).run
      render json: users.map { |u| { email: u.email } }
    end

  end
end
