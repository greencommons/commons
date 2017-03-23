module Api
  module V1
    class ResourcesController < ApiController
      def show
        render json: present(Resource.find(params[:id]))
      end
    end
  end
end
