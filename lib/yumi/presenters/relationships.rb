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
        Yumi::Utils::PresenterHelper.presenter_from_rel(@presenter.url,
                                                        rel,
                                                        @presenter.resource.send(rel),
                                                        @presenter.presenter_module,
                                                        @presenter.prefix)
      end
    end
  end
end
