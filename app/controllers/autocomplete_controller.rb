class AutocompleteController < ApplicationController
  before_action :authenticate_user!

  def members
    users = Suggesters::Members.new(query: params[:q], group_id: params[:group_id]).suggest
    render json: users.map { |u| { email: u.email } }
  end

  def lists
    lists = Suggesters::Lists.new(query: params[:q],
                                  except: current_resource.lists).suggest
    render json: { items: lists }
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
