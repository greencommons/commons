module Api
  class ApiController < ActionController::API
    include Pundit
    include Authentication
    include Search

    before_action :set_paper_trail_whodunnit

    rescue_from StandardError, with: :server_error
    rescue_from Pundit::NotAuthorizedError, with: :forbidden
    rescue_from ActionController::ParameterMissing, with: :client_error

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

    def present_errors(resource, errors)
      Yumi::Presenter.new(url: base_url,
                          current_url: request.original_url,
                          resource: resource,
                          params: params.to_unsafe_hash,
                          errors: errors,
                          presenters_module: "::#{version}".constantize).as_json_api
    end

    def render_json_api(data, status: 200)
      render status: status, json: data, content_type: 'application/vnd.api+json'
    end

    def server_error(e)
      render_json_api_error(e, 500)
    end

    def client_error(e)
      render_json_api_error(e, 400)
    end

    def forbidden
      render_json_api_error({
                              title: 'Forbidden',
                              message: "You don't have the permission to do that."
                            }, 403)
    end

    def render_json_api_error(error, status = 400)
      render(status: status, content_type: 'application/vnd.api+json', json: {
               errors: [{
                 status: status,
                 title: error.is_a?(Hash) ? error[:title] : error.class.name,
                 detail: error.is_a?(Hash) ? error[:message] : error.message
               }]
             })
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
