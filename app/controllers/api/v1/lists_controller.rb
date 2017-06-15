module Api
  module V1
    class ListsController < ApiController
      skip_before_action :validate_auth_scheme, only: %i(show)
      skip_before_action :authenticate_client, only: %i(show)

      def show
        render_json_api present_entity(List.find(params[:id]))
      end

      def create
        @list = List.new(list_params)
        @list.owner = owner
        authorize @list

        if @list.save
          @list.touch
          render_json_api present_entity(@list)
        else
          render_json_api present_errors(@list, [@list.errors]), status: 400
        end
      end

      private

      def owner
        return current_user unless list_params[:owner_id] && list_params[:owner_type]
        return current_user unless %w(Network User).include?(list_params[:owner_type])
        list_params[:owner_type].constantize.find(list_params[:owner_id]) || current_user
      end

      def list_params
        params.require(:data).
          require(:attributes).
          permit(:name, :description, :tag_list, :privacy, :owner_id, :owner_type)
      end
    end
  end
end
