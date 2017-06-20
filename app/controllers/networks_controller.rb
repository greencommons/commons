class NetworksController < ApplicationController
  before_action :authenticate_user!, except: %i(show)
  before_action :set_network, only: %i(show edit update destroy leave)

  def index
    @networks = policy_scope(Network).page(params[:page] || 1).per(10)
  end

  def show
    @resources = @network.latest_resources
    @lists = @network.owned_lists.order(created_at: :desc)
    @similar = Suggesters::Tags.new(tags: @network.cached_tags,
                                    except: @network,
                                    limit: 12,
                                    models: [Network]).suggest
    @network_current_user = @network.find_member(current_user)
    @admin = @network_current_user.try(:admin?)
  end

  def new
    @network = Network.new
    authorize @network
  end

  def edit; end

  def create
    @network = Network.new(network_params)
    authorize @network

    if @network.save
      @network.touch
      @network.add_admin(current_user)
      redirect_to @network, notice: 'Network was successfully created.'
    else
      render :new
    end
  end

  def update
    if @network.update(network_params)
      @network.touch
      redirect_to @network, notice: 'Network was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @network.destroy
    redirect_to networks_url, notice: 'Network was successfully destroyed.'
  end

  private

  def set_network
    @network = Network.find(params[:id])
    authorize @network
  end

  def network_params
    params.require(:network).permit(:name, :short_description, :long_description,
                                    :tag_list, :url, :email)
  end
end
