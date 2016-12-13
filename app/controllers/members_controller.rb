class MembersController < ApplicationController
  before_action :authenticate_user!, only: [:make_admin, :remove_admin, :destroy]
  before_action :set_group
  before_action :set_group_user, except: [:index]
  before_action :set_is_admin
  before_action :check_admin_rights, except: [:index]

  def index
    @members = @group.groups_users.includes(:user)
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

    def set_is_admin
      @is_admin = @group.is_admin?(current_user)
    end

    def toggle_admin(admin)
      if @group_user.update(admin: admin)
        redirect_to group_members_path(@group), notice: 'Member was successfully updated.'
      else
        redirect_to group_members_path(@group), alert: 'The member could not be updated.'
      end
    end

    def check_admin_rights
      unless @is_admin
        redirect_to group_members_path(@group), alert: "You don't have the rights to do that."
      end
    end
end
