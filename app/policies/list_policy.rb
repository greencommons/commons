class ListPolicy < ApplicationPolicy
  attr_reader :user, :list

  def initialize(user, list)
    @user = user
    @list = list
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
    @user && @list.owner == @user
  end

  def edit?
    @user && @list.owner == @user
  end

  def destroy?
    @user && @list.owner == @user
  end

  def scope
    Pundit.policy_scope!(user, List)
  end

  class Scope < Scope
    def resolve
      scope.where('owner_id = ?', user.id)
    end
  end
end
