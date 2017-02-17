class ResourcePolicy < ApplicationPolicy
  attr_reader :user, :resource

  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def index?
    @user
  end

  def show?
    return true unless @resource.priv?
    @user && @resource.user == @user
  end

  def new?
    @user
  end

  def create?
    @user
  end

  def edit?
    @user && @resource.user == @user
  end

  def update?
    @user && @resource.user == @user
  end

  def destroy?
    @user && @resource.user == @user
  end

  def scope
    Pundit.policy_scope!(user, Resource)
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
