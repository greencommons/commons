module Api
  class ApiController < ActionController::API
    def base_url
      "#{request.base_url}/api/#{self.class.name.split('::')[1].downcase}"
    end
  end
end
