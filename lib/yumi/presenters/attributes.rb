# app/yumi/presenters/attributes.rb
module Yumi
  module Presenters
    class Attributes
      def initialize(presenter)
        @presenter = presenter
        @resource = @presenter.resource
      end

      def to_json_api
        fields.each_with_object({}) do |attr, hash|
          hash[attr] = (@presenter.respond_to?(attr) ? @presenter : @resource).send(attr)
        end
      end

      private

      def fields
        return @presenter.attributes unless @presenter.fields
        return @presenter.attributes unless @presenter.fields[@presenter.type.pluralize]

        model_fields = @presenter.fields[@presenter.type.pluralize].split(',').map(&:to_sym)
        model_fields.any? ? (@presenter.attributes & model_fields) : @presenter.attributes
      end
    end
  end
end
