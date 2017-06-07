module Yumi
  class Parser
    def initialize(body)
      @body = body
    end

    def type
      @type ||= @data[:type]
    end

    def attributes
      @attributes ||= @data[:attributes]
    end

    def relationships
      @relationships ||= @data[:relationships]
    end

    def data
      @data ||= @body[:data]
    end
  end
end
