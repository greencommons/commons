class AutocompleteController < ApplicationController
  before_action :authenticate_user!

  def members
    users = Suggesters::Members.new(query: params[:q], group_id: params[:group_id]).suggest
    render json: users.map { |u| { email: u.email } }
  end

  def lists
    current = params[:current_resource].split(':')
    current = current[0].constantize.find(current[1])

    lists = Suggesters::Lists.new(query: params[:q],
                                  except: current).suggest
    render json: { items: lists.map { |l| { id: l.id, name: l.name } } }
  end
end
