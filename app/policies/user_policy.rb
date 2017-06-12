class UserPolicy < ApplicationPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def index?
    @current_user
  end

  def show?
    @current_user == @user
  end

  def create?
    @current_user
  end

  def new?
    @current_user
  end

  def update?
    @current_user == @user
  end

  def edit?
    @current_user == @user
  end

  def destroy?
    @current_user == @user
  end
end
