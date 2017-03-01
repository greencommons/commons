module Api
  module V1
    class SearchController < ApiController
      def show
        @groups = Group.limit(10)
        render json: @groups.page(params[:page] || 1).per(10)
      end
    end
  end
end
