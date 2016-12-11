module Api
  class AutocompleteController < ApplicationController
    before_action :authenticate_user!

    def members
      users = User.filter_by_email(params[:q]).sort_by_email.limit(10).map { |u| u.email }

      members = Group.where(id: params[:group_id]).first.try(:users)
      members = members && members.any? ? members.map { |u| u.email } : []

      users = (members.any? ? [users - members].flatten : users).map { |email| { email: email } }

      render json: users
    end

  end
end
