module Api
  module V1
    class GroupsController < ApiController
      def show
        @group = Group.find(params[:id])
        render json: @group
      end
    end
  end
end
