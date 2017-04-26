module Yumi
  module Utils
    class PresenterHelper
      def initialize(url:, resource:, fields: nil, presenter_module: nil, prefix: nil)
        @url = url
        @resource = resource
        @fields = fields
        @presenter_module = presenter_module
        @prefix = prefix
      end

      def presenter
        @resource_class = @resource.class
        presenter_instance
      end

      def presenter_from_rel(rel)
        @resource_class = rel.to_s.singularize.capitalize
        presenter_instance
      end

      private

      def presenter_instance
        presenter_class.constantize.new(@url, @resource, @presenter_module, @prefix, @fields)
      end

      def presenter_class
        if @presenter_module
          "#{@presenter_module}::#{@resource_class}Presenter"
        else
          "#{@resource_class}Presenter"
        end
      end
    end
  end
end
