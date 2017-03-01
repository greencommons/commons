module Api
  module V1
    class ListsController < ApiController
      def show
        @list = List.find(params[:id])
        render json: @list, serializer: ::V1::ListSerializer
      end
    end
  end
end
