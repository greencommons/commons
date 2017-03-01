module Api
  module V1
    class ListsController < ApiController
      def show
        @list = List.find(params[:id])
        render json: @list
      end
    end
  end
end
