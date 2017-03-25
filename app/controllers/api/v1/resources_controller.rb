module Api
  module V1
    class ResourcesController < ApiController
      def show
        render_json_api present_entity(Resource.find(params[:id]))
      end
    end
  end
end
