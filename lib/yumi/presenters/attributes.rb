# app/yumi/presenters/attributes.rb
module Yumi
  module Presenters
    class Attributes
      def initialize(presenter)
        @presenter = presenter
        @resource = @presenter.resource
      end

      def to_json_api
        @presenter.attributes.each_with_object({}) do |attr, hash|
          hash[attr] = (@presenter.respond_to?(attr) ? @presenter : @resource).send(attr)
        end
      end
    end
  end
end
