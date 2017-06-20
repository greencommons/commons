module Api
  module V1
    module Relationships
      class ItemsController < ApiController
        skip_before_action :validate_auth_scheme, only: %i(index)
        skip_before_action :authenticate_client, only: %i(index)

        before_action :set_list

        def index
          results = @list.lists_items.includes(:item).
                    page(params[:page] || 1).per(params[:per] || 10)
          render_json_api present_collection(results, @list.lists_items.count)
        end

        def create
          authorize @list, :update?

          items = Actions::CreateListItems.new(params, @list).run
          items.each do |item|
            authorize item
            item.save
          end

          results = @list.lists_items.includes(:item).
                    page(params[:page] || 1).per(params[:per] || 10)
          render_json_api present_collection(results, @list.lists_items.count)
        end

        def update
          render_json_api_error({
                                  title: 'Forbidden',
                                  message: 'Complete replacement is not allowed for this resource.'
                                }, 403)
        end

        def destroy
          authorize @list, :update?
          params[:data].each do |item|
            unless %w(networks resources).include?(item[:type])
              raise ActionController::ParameterMissing.new(:item_type)
            end

            ListsItem.where(
              list_id: @list.id,
              item_id: item[:id],
              item_type: item[:type].singularize.capitalize
            ).first.try(:destroy)
          end

          results = @list.lists_items.includes(:item).
                    page(params[:page] || 1).per(params[:per] || 10)
          render_json_api present_collection(results, @list.lists_items.count)
        end

        private

        def set_list
          @list = List.find(params[:list_id])
        end
      end
    end
  end
end
