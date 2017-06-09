module Yumi
  module Presenters
    class Data
      def initialize(presenter)
        @presenter = presenter
      end

      def to_json_api
        {
          type: type,
          id: id,
          attributes: Yumi::Presenters::Attributes.new(@presenter).to_json_api,
          links: Yumi::Presenters::Links.new(@presenter).to_json_api,
          relationships: Yumi::Presenters::Relationships.new(@presenter).to_json_api
        }
      end

      private

      def type
        @type ||= if @presenter.respond_to?(:resource_type)
                    @presenter.resource_type(@presenter.resource)
                  else
                    @presenter.type.pluralize
                  end
      end

      def id
        @id ||= if @presenter.respond_to?(:resource_id)
                  @presenter.resource_id
                else
                  @presenter.resource.id
                end.to_s
      end
    end
  end
end
