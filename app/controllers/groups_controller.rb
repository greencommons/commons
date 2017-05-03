class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_group, only: [:show, :edit, :update, :destroy, :leave]

  def index
    @groups = policy_scope(Group).page(params[:page] || 1).per(10)
  end

  def show
    @resources = @group.latest_resources
    @group_current_user = @group.find_member(current_user)
    @admin = @group_current_user.try(:admin?)
  end

  def new
    @group = Group.new
    authorize @group
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
    authorize @group

    if @group.save
      @group.add_admin(current_user)
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  private

  def set_group
    @group = Group.find(params[:id])
    authorize @group
  end

  def group_params
    params.require(:group).permit(:name, :short_description, :long_description, :url, :email)
  end
end
