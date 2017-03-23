module Api
  module V1
    class ListsController < ApiController
      def show
        render json: present(List.find(params[:id]))
      end
    end
  end
end
