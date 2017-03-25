module Api
  class ApiController < ActionController::API
    before_action :set_paper_trail_whodunnit

    def base_url
      "#{request.base_url}/api/#{version.downcase}"
    end

    def present_collection(resource, total)
      Yumi::Presenter.new(url: base_url,
                          current_url: request.original_url,
                          resource: resource,
                          total: total,
                          params: query_params,
                          presenters_module: "::#{version}".constantize).as_json_api
    end

    def present_entity(resource)
      Yumi::Presenter.new(url: base_url,
                          current_url: request.original_url,
                          resource: resource,
                          params: query_params,
                          presenters_module: "::#{version}".constantize).as_json_api
    end

    def render_json_api(data)
      render json: data, content_type: 'application/vnd.api+json'
    end

    private

    def query_params
      params.permit(:q, :filters,  :sort, :include, :page, :per)&.to_unsafe_hash
    end

    def version
      self.class.name.split('::')[1]
    end
  end
end
