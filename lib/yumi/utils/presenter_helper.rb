module Yumi
  module Utils
    class PresenterHelper
      def self.presenter_for(url, resource, presenter_module = nil, prefix = nil)
        klass_name = if presenter_module
          "#{presenter_module}::#{resource.class}Presenter"
        else
          "#{resource.class}Presenter"
        end

        klass_name.constantize.new(@url, resource, presenter_module, prefix)
      end

      def self.presenter_from_rel(url, rel, resource, presenter_module = nil, prefix = nil)
        klass_name = if presenter_module
          "#{presenter_module}::#{rel.to_s.singularize.capitalize}Presenter"
        else
          "#{rel.to_s.singularize.capitalize}Presenter"
        end

        klass_name.constantize.new(@url, resource, presenter_module, prefix)
      end
    end
  end
end
