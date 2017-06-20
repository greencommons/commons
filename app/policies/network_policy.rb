class NetworkPolicy < ApplicationPolicy
  attr_reader :user, :network

  def initialize(user, network)
    @user = user
    @network = network
  end

  def index?
    @user
  end

  def show?
    true
  end

  def create?
    @user
  end

  def new?
    @user
  end

  def update?
    @network.admin?(@user)
  end

  def edit?
    @network.admin?(@user)
  end

  def destroy?
    @network.admin?(@user)
  end

  def scope
    Pundit.policy_scope!(user, Network)
  end

  class Scope < Scope
    def resolve
      scope.joins(:networks_users).where('user_id = ?', user.id)
    end
  end
end
