# frozen_string_literal: true
class GroupPolicy < ApplicationPolicy
  attr_reader :user, :group

  def initialize(user, group)
    @user = user
    @group = group
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
    @group.admin?(@user)
  end

  def edit?
    @group.admin?(@user)
  end

  def destroy?
    @group.admin?(@user)
  end

  def scope
    Pundit.policy_scope!(user, Group)
  end

  class Scope < Scope
    def resolve
      scope.joins(:groups_users).where("user_id = ?", user.id)
    end
  end
end
