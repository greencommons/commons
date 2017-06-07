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
    return true unless @list.priv?
    @user && owned?
  end

  def create?
    @user
  end

  def new?
    @user
  end

  def update?
    @user && owned?
  end

  def edit?
    @user && owned?
  end

  def destroy?
    @user && owned?
  end

  def owned?
    if @list.owner.is_a?(Group)
      !@list.owner.find_member(@user).nil?
    else
      @list.owner == @user
    end
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
