module Yumi
  module Presenters
    class Links
      def initialize(presenter)
        @presenter = presenter
      end

      def to_json_api
        @presenter.links.each_with_object({}) do |link_type, hash|
          hash[link_type] = send("#{link_type}_link")
        end
      end

      private

      def self_link
        if @presenter.resource.respond_to?(:each)
          "#{@presenter.url}/#{@presenter.type.pluralize}"
        else
          type = if @presenter.override_type
                   @presenter.resource_type(@presenter.resource)
                 else
                   @presenter.type.pluralize
                 end

          "#{@presenter.url}/#{type}/#{@presenter.pid(@presenter.resource)}"
        end
      end
    end
  end
end
