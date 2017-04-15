module Api
  module V1
    class GroupsController < ApiController
      def show
        render_json_api present_entity(Group.find(params[:id]))
      end
    end
  end
end
