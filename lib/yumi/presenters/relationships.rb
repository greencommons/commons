module Yumi
  module Presenters
    class Relationships
      def initialize(presenter)
        @presenter = presenter
      end

      def to_json_api
        @presenter.relationships.each_with_object({}) do |rel, hash|
          hash[rel] = presenter(rel).as_relationship
        end
      end

      private

      def prefix
        @prefix ||= "#{@presenter.type.pluralize}/#{@presenter.resource.id}/"
      end

      def presenter(rel)
        Yumi::Utils::PresenterHelper.new(url: @presenter.url,
                                         resource: @presenter.resource.send(rel),
                                         presenter_module: @presenter.presenter_module,
                                         prefix: prefix).presenter_from_rel(rel)
      end
    end
  end
end
