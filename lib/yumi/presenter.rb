module Yumi
  class Presenter
    def initialize(url:, current_url:, resource:, params: {}, total: nil,
                   presenters_module: nil, meta: {})
      @url = url
      @current_url = current_url
      @resource = resource
      @params = params.slice(:q, :filters, :sort, :page, :per)
      @includes = params[:include]&.split(',') || []
      @total = total
      @presenters_module = presenters_module
      @meta = meta
      @included_resources = {}
    end

    def as_json_api
      json = {
        data: data,
        links: Yumi::Presenters::RootLinks.new(@current_url,
                                               @params,
                                               @total,
                                               collection?).to_json_api,
        included: included
      }
      json[:meta] = @meta if @meta.any?
      json
    end

    private

    def data
      if collection?
        @resource.map do |r|
          Yumi::Presenters::Data.new(presenter_for(r)).to_json_api
        end
      else
        Yumi::Presenters::Data.new(presenter_for(@resource)).to_json_api
      end
    end

    def included
      klass = Yumi::Presenters::IncludedResources

      if collection?
        @resource.map do |r|
          klass.new(presenter_for(r), @includes, @included_resources).
            to_json_api
        end.flatten.uniq
      else
        klass.new(presenter_for(@resource), @includes, @included_resources).
          to_json_api
      end
    end

    def presenter_for(resource)
      Yumi::Utils::PresenterHelper.new(url: @url,
                                       resource: resource,
                                       presenter_module: @presenters_module).presenter
    end

    def collection?
      @collection ||= @resource.respond_to?(:each)
    end
  end
end
