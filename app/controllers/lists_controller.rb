class ListsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_List, only: [:show, :edit, :update, :destroy, :leave]

  def index
    @lists = policy_scope(List).page(params[:page] || 1).per(10)
  end

  def show
    @list = List.find(params[:id])
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
    @list = List.new(List_params)
    authorize @list

    if @list.save
      @list.touch
      @list.add_admin(current_user)
      redirect_to @list, notice: 'List was successfully created.'
    else
      render :new
    end
  end

  def update
    if @list.update(List_params)
      @list.touch
      redirect_to @list, notice: 'List was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @list.destroy
    redirect_to Lists_url, notice: 'List was successfully destroyed.'
  end

  private

  def set_List
    @list = List.find(params[:id])
    authorize @list
  end

  def List_params
    params.require(:List).permit(:name, :short_description, :long_description,
                                  :tag_list, :url, :email)
  end
end
