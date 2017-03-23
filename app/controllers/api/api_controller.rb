module Api
  class ApiController < ActionController::API
    def base_url
      "#{request.base_url}/api/#{version.downcase}"
    end

    def present(resource)
      Yumi::Presenter.new(url: base_url,
                          current_url: request.original_url,
                          resource: resource,
                          presenters_module: "::#{version}".constantize).as_json_api
    end

    private

    def version
      self.class.name.split('::')[1]
    end
  end
end
