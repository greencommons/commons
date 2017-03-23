module Api
  module V1
    class GroupsController < ApiController
      def show
        render json: present(Group.find(params[:id]))
      end
    end
  end
end
