module Yumi
  module Presenters
    class RootLinks
      def initialize(current_url)
        @current_url = current_url
      end

      def to_json_api
        {
          self: @current_url,
          next: '',
          last: ''
        }
      end
    end
  end
end
