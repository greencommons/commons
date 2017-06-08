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
        return nil unless params[:list][:owner]
        owner = params[:list][:owner].split(':')
        return nil unless %w(Group User).include?(owner[0])
        owner[0].constantize.find(owner[1]) || current_user
      end

      def list_params
        params.require(:data).
          require(:attributes).
          permit(:name, :description, :tag_list, :privacy)
      end
    end
  end
end
