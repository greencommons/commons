class GroupsUserPolicy < ApplicationPolicy
  attr_reader :user, :group_user

  def initialize(user, group_user)
    @user = user
    @group_user = group_user
  end

  def leave?
    @user == @group_user.user
  end
end
