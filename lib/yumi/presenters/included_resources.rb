module Yumi
  module Presenters
    class IncludedResources
      def initialize(presenter, included_resources = {})
        @presenter = presenter
        @included_resources = included_resources
      end

      def to_json_api
        if @presenter.resource.respond_to?(:each)
          @presenter.resource.each { |r| included_data(r, @included_resources) }
        else
          included_data(@presenter.resource, @included_resources)
        end
        @included_resources.values
      end

      private

      def included_data(resource, hash)
        @presenter.relationships.each do |rel|
          associated_resource = resource.send(rel)

          if associated_resource.respond_to?(:each)
            associated_resource.each do |r|
              key = "#{rel}:#{r.id}"

              unless hash[key]
                hash[key] = presenter(rel, r).as_included
              end
            end
          else
            key = "#{rel}:#{associated_resource.id}"

            unless hash[key]
              hash[key] = presenter(rel, associated_resource).as_included
            end
          end
        end
      end

      def presenter(rel, associated_resource)
        Yumi::Utils::PresenterHelper.new(url: @presenter.url,
                                         resource: associated_resource,
                                         presenter_module: @presenter.presenter_module,
                                         prefix: @presenter.prefix).presenter_from_rel(rel)
      end
    end
  end
end
