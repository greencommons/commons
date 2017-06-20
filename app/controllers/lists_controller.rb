class ListsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_list, only: %i(show edit destroy leave)

  def index
    @lists = policy_scope(List).page(params[:page] || 1).per(10)
  end

  def show
    @list = List.find(params[:id])
    @sort = params[:sort] || 'published_at'
    @page = params[:page] || 1

    @items = @list.lists_items.
             includes(:item).
             order("#{@sort} DESC").
             page(@page).
             per(12)

    @similar = Suggesters::Tags.new(tags: @list.cached_tags,
                                    except: @list,
                                    limit: 12,
                                    models: [List]).suggest

    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @list = List.new
    authorize @list
  end

  def edit
  end

  def create
    @list = List.new(list_params)
    @list.owner = owner
    authorize @list

    if @list.save
      @list.touch
      redirect_to @list, notice: 'List was successfully created.'
    else
      render :new
    end
  end

  def update
    @list = List.find(params[:id])
    @list.owner = owner
    authorize @list

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

  def owner
    return nil unless params[:list][:owner]
    owner = params[:list][:owner].split(':')
    return nil unless %w(Network User).include?(owner[0])
    owner[0].constantize.find(owner[1]) || current_user
  end

  def list_params
    params.require(:list).permit(:name, :description, :tag_list, :privacy)
  end
end
