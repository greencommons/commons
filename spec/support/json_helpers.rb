# frozen_string_literal: true
module JSONHelpers
  def json_body
    JSON.parse(response.body)
  end
end

RSpec.configure do |c|
  c.include JSONHelpers
end
