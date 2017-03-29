module Yumi
  module Presenters
    class Data
      def initialize(presenter)
        @presenter = presenter
      end

      def to_json_api
        {
          type: @presenter.type.pluralize,
          id: @presenter.resource.id.to_s,
          attributes: Yumi::Presenters::Attributes.new(@presenter).to_json_api,
          links: Yumi::Presenters::Links.new(@presenter).to_json_api,
          relationships: Yumi::Presenters::Relationships.new(@presenter).to_json_api
        }
      end
    end
  end
end
