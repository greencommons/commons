module Api
  module V1
    class ListsController < ApiController
      def show
        render_json_api present(List.find(params[:id]))
      end
    end
  end
end
