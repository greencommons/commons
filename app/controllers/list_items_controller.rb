class ListItemsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def create
    if policy(list).update?
      if valid_type? && item
        list_item.list = list
        list_item.item = item
        list_item.published_at = item.published_at
        authorize list_item

        if list_item.save
          render json: {
            status: 'ok',
            list_name: list.name,
            resource_name: item.name,
            list_count: item.lists.count
          }
        else
          render_errors(list_item.errors)
        end
      else
        render_errors('Item Type' => ['is not valid. Supported types: Group, Resource, List.'])
      end
    else
      render_errors('Unauthorized: ' => ["You don't have the permission to do that."])
    end
  end

  def destroy
    @list_item = ListsItem.find(params[:id])
    @list = @list_item.list

    @sort = params[:sort] || 'published_at'
    @page = params[:page] || 1
    @list_item.destroy if policy(list).update?

    @items = @list.lists_items.
             includes(:item).
             order("#{@sort} DESC").
             page(params[:page] || 1).
             per(12)

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @list_item = ListsItem.find(params[:id])

    @list = @list_item.list
    @sort = params[:sort] || 'published_at'
    @page = params[:page] || 1

    @list_item.destroy

    @items = @list.lists_items.
             includes(:item).
             order("#{@sort} DESC").
             page(params[:page] || 1).
             per(12)

    respond_to do |format|
      format.js
    end
  end

  private

  def valid_type?
    %w(Group Resource List).include?(params[:list_item][:item_type])
  end

  def list_item
    @list_item ||= @list_item = ListsItem.new(list_item_params)
  end

  def list
    @list ||= List.find(params[:list_item][:list_id])
  end

  def item
    @item ||= params[:list_item][:item_type].constantize.find(
      params[:list_item][:item_id]
    )
  end

  def render_errors(errors)
    render status: 400, json: {
      status: 'ko',
      list_name: list.name,
      resource_name: item.name,
      list_count: item.lists.count,
      errors: errors
    }
  end

  def list_item_params
    params.require(:list_item).permit(:note)
  end
end
