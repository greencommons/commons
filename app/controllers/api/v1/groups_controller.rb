module Api
  module V1
    class GroupsController < ApiController
      skip_before_action :validate_auth_scheme, only: %i(index show)
      skip_before_action :authenticate_client, only: %i(index show)

      def index
        data, = search(models: [Group])
        render_json_api data
      end

      def show
        render_json_api present_entity(Group.find(params[:id]))
      end

      def create
        @group = Group.new(group_params)
        authorize @group

        if @group.save
          @group.touch
          @group.add_admin(current_user)
          render_json_api present_entity(@group)
        else
          render_json_api present_errors(@group, [@group.errors]), status: 400
        end
      end

      def update
        @group = Group.find(params[:id])
        authorize @group

        if @group.update(group_params)
          @group.touch
          render_json_api present_entity(@group)
        else
          render_json_api present_errors(@group, [@group.errors]), status: 400
        end
      end

      private

      def group_params
        params.require(:data).
          require(:attributes).
          permit(:name, :short_description, :long_description,
                 :tag_list, :url, :email)
      end
    end
  end
end
