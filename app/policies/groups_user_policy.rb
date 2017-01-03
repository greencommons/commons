class GroupsUserPolicy < ApplicationPolicy
  attr_reader :user, :group_user

  def initialize(user, group_user)
    @user = user
    @group_user = group_user
  end

  def join?
    return false unless @user
    @existing_group_user = GroupsUser.where(user: @user, group: @group_user.group).first
    @existing_group_user.nil? && @user == @group_user.user
  end

  def leave?
    @user && @group_user.persisted? && @user == @group_user.user
  end
end
