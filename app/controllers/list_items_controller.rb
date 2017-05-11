class ListItemsController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def create
    @list_item = ListsItem.new(list_item_params)
    # authorize @list_item

    if @list_item.save
      render json: {
        status: 'ok',
        list_name: @list_item.list.name,
        resource_name: @list_item.item.name,
        list_count: @list_item.item.lists.count
      }
    else
      render json: {
        status: 'ko',
        list_name: @list_item.list.name,
        resource_name: @list_item.item.name,
        errors: @list_item.errors
      }
    end
  end

  private

  def list_item_params
    params.require(:list_item).permit(:list_id, :item_id, :item_type, :note)
  end
end
