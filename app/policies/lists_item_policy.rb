class ListsItemPolicy < ApplicationPolicy
  attr_reader :user, :list_item

  def initialize(user, list_item)
    @user = user
    @list_item = list_item
  end

  def create?
    return false unless @user
    true
  end

  def destroy?
    return false unless @user
    true
  end
end
