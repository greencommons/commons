class MembersController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_group
  before_action :set_group_user, except: [:index, :create]
  before_action :set_admin
  before_action :check_admin_rights, except: [:index]

  def index
    @members = @group.groups_users.includes(:user)
  end

  def create
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
    toggle_admin(true)
  end

  def remove_admin
    toggle_admin(false)
  end

  def destroy
    @group_user.destroy
    redirect_to group_members_path(@group), notice: 'Member was successfully removed.'
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

  def check_admin_rights
    unless @admin
      redirect_to group_members_path(@group), alert: "You don't have the rights to do that."
    end
  end
end
