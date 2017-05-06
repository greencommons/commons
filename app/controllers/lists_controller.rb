class ListsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_list, only: [:show, :edit, :update, :destroy, :leave]

  def index
    @lists = policy_scope(List).page(params[:page] || 1).per(10)
  end

  def show
    @list = List.find(params[:id])
    @items = @list.lists_items.sorted.page(params[:page] || 1).per(12)
    @similar = Suggesters::Tags.new(tags: @list.cached_tags,
                                    except: @list,
                                    limit: 12,
                                    models: [List]).suggest
  end

  def new
    @list = List.new
    authorize @list
  end

  def edit
  end

  def create
    @list = List.new(list_params)
    authorize @list

    @list.owner = current_user
    if @list.save
      @list.touch
      redirect_to @list, notice: 'List was successfully created.'
    else
      render :new
    end
  end

  def update
    if @list.update(list_params)
      @list.touch
      redirect_to @list, notice: 'List was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @list.destroy
    redirect_to lists_url, notice: 'List was successfully destroyed.'
  end

  private

  def set_list
    @list = List.find(params[:id])
    authorize @list
  end

  def list_params
    params.require(:list).permit(:name, :description, :tag_list, :privacy)
  end
end
