class ListsItemPolicy < ApplicationPolicy
  attr_reader :user, :list_item

  def initialize(user, list_item)
    @user = user
    @list_item = list_item
  end

  def create?
    @user && ListPolicy.new(@user, @list_item.list).update?
  end

  def destroy?
    @user && ListPolicy.new(@user, @list_item.list).update?
  end
end
