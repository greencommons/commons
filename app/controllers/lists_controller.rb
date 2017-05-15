class ListsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_list, only: [:show, :edit, :update, :destroy, :leave]
  before_action :set_owner_suggestions, only: [:new, :edit]

  def index
    @lists = policy_scope(List).page(params[:page] || 1).per(10)
  end

  def show
    @list = List.find(params[:id])

    @sort = params[:sort] || 'published_at'

    @items = @list.lists_items.
             includes(:item).
             order("#{@sort} DESC").
             page(params[:page] || 1).
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
    authorize @list

    @list.owner = owner
    if @list.save
      @list.touch
      redirect_to @list, notice: 'List was successfully created.'
    else
      render :new
    end
  end

  def update
    @list.owner = owner
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

  def set_owner_suggestions
    @owner_suggestions = Group.all.map { |g| [g.name, "Group:#{g.id}"] } +
                         User.all.map { |u| [u.name.presence || u.email, "User:#{u.id}"] }
  end

  def owner
    owner = params[:list][:owner].split(':')
    return current_user unless %w(Group User).include?(owner[0])
    owner[0].constantize.find(owner[1]) || current_user
  end

  def list_params
    params.require(:list).permit(:name, :description, :tag_list, :privacy)
  end
end
