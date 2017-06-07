module Api
  class ApiController < ActionController::API
    include Pundit
    include Authentication

    before_action :set_paper_trail_whodunnit

    rescue_from Pundit::NotAuthorizedError, with: :forbidden

    def base_url
      "#{request.base_url}/api/#{version.downcase}"
    end

    def present_collection(resource, total)
      Yumi::Presenter.new(url: base_url,
                          current_url: request.original_url,
                          resource: resource,
                          total: total,
                          params: params.to_unsafe_hash,
                          presenters_module: "::#{version}".constantize).as_json_api
    end

    def present_entity(resource)
      Yumi::Presenter.new(url: base_url,
                          current_url: request.original_url,
                          resource: resource,
                          params: params.to_unsafe_hash,
                          presenters_module: "::#{version}".constantize).as_json_api
    end

    def render_json_api(data)
      render json: data, content_type: 'application/vnd.api+json'
    end

    def forbidden
      render(status: 403)
    end

    private

    def version
      self.class.name.split('::')[1]
    end
  end
end
