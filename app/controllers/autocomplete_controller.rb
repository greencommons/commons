class AutocompleteController < ApplicationController
  before_action :authenticate_user!

  def members
    users = Suggesters::Members.new(query: params[:q], network_id: params[:network_id]).suggest
    render json: users.map { |u| { email: u.email } }
  end

  def lists
    allowed_lists = current_user.all_owned_lists.
                    where.not(id: current_resource.lists.pluck(:id))
    lists = Suggesters::Lists.new(query: params[:q],
                                  only: allowed_lists).suggest
    render json: { items: lists }
  end

  def list_owners
    list_owners = Suggesters::ListOwners.new(query: params[:q]).suggest
    render json: { items: list_owners }
  end

  private

  def current_resource
    @current_resource ||= lambda do
      return nil unless params[:current_resource]
      current = params[:current_resource].split(':')
      current[0].constantize.find(current[1])
    end.call
  end
end
