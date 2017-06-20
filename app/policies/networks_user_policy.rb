class NetworksUserPolicy < ApplicationPolicy
  attr_reader :user, :network_user

  def initialize(user, network_user)
    @user = user
    @network_user = network_user
  end

  def join?
    return false unless @user
    @existing_network_user = NetworksUser.where(user: @user, network: @network_user.network).first
    @existing_network_user.nil? && @user == @network_user.user
  end

  def leave?
    @user && @network_user.persisted? && @user == @network_user.user
  end
end
