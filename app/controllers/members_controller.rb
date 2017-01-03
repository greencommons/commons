class MembersController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_group
  before_action :set_group_user, except: [:index, :create, :join, :leave]
  before_action :set_admin, except: [:join, :leave]

  def index
    authorize @group, :show?
    @members = @group.groups_users.includes(:user)
  end

  def create
    authorize @group, :update?
    user = User.where(email: params[:email]).first

    notice =
      if user
        if @group.add_user(user)
          'Member was successfully added.'
        else
          'Member already in group.'
        end
      else
        'User not found.'
      end

    redirect_to group_members_path(@group), notice: notice
  end

  def make_admin
    authorize @group, :update?
    toggle_admin(true)
  end

  def remove_admin
    authorize @group, :update?
    toggle_admin(false)
  end

  def destroy
    authorize @group, :update?
    @group_user.destroy
    redirect_to group_members_path(@group), notice: 'Member was successfully removed.'
  end

  def join
    @group_current_user = @group.groups_users.new(user: current_user)
    authorize @group_current_user

    if @group_current_user.save
      redirect_to @group, notice: "Welcome to the '#{@group.name}' group!"
    else
      redirect_to @group, notice: 'We couldn\'t add you to this group.'
    end
  end

  def leave
    @group_current_user = @group.find_member(current_user)
    authorize @group_current_user

    if !@group_current_user.admin? || @group.admin_count > 1
      @group_current_user.destroy
      redirect_to @group, notice: 'You are no longer a member of this group.'
    else
      redirect_to @group, notice: 'You cannot leave this group because you are the only admin.'
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_group_user
    @group_user = GroupsUser.find(params[:id])
  end

  def set_admin
    @admin = @group.admin?(current_user)
  end

  def toggle_admin(admin)
    if @group_user.update(admin: admin)
      redirect_to group_members_path(@group), notice: 'Member was successfully updated.'
    else
      redirect_to group_members_path(@group), alert: 'The member could not be updated.'
    end
  end
end
