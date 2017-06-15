class MembersController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_network
  before_action :set_network_user, except: [:index, :create, :join, :leave]
  before_action :set_admin, except: [:join, :leave]

  def index
    authorize @network, :show?
    @members = @network.networks_users.includes(:user)
  end

  def create
    authorize @network, :update?
    user = User.where(email: params[:email]).first

    notice =
      if user
        if @network.add_user(user)
          'Member was successfully added.'
        else
          'Member already in network.'
        end
      else
        'User not found.'
      end

    redirect_to network_members_path(@network), notice: notice
  end

  def make_admin
    authorize @network, :update?
    toggle_admin(true)
  end

  def remove_admin
    authorize @network, :update?
    toggle_admin(false)
  end

  def destroy
    authorize @network, :update?
    @network_user.destroy
    redirect_to network_members_path(@network), notice: 'Member was successfully removed.'
  end

  def join
    @network_current_user = @network.networks_users.new(user: current_user)
    authorize @network_current_user

    if @network_current_user.save
      redirect_to @network, notice: "Welcome to the '#{@network.name}' network!"
    else
      redirect_to @network, alert: 'We couldn\'t add you to this network.'
    end
  end

  def leave
    @network_current_user = @network.find_member(current_user)
    authorize @network_current_user

    if !@network_current_user.admin? || @network.admin_count > 1
      @network_current_user.destroy
      redirect_to @network, notice: 'You are no longer a member of this network.'
    else
      redirect_to @network, alert: 'You cannot leave this network because you are the only admin.'
    end
  end

  private

  def set_network
    @network = Network.find(params[:network_id])
  end

  def set_network_user
    @network_user = NetworksUser.find(params[:id])
  end

  def set_admin
    @admin = @network.admin?(current_user)
  end

  def toggle_admin(admin)
    if @network_user.update(admin: admin)
      redirect_to network_members_path(@network), notice: 'Member was successfully updated.'
    else
      redirect_to network_members_path(@network), alert: 'The member could not be updated.'
    end
  end
end
