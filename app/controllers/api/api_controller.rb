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

    def render_json_api(data)
      render json: data, content_type: 'application/vnd.api+json'
    end

    private

    def version
      self.class.name.split('::')[1]
    end
  end
end
