module SearchBuilders
  class Query
    def initialize(query, es_params)
      @query = query
      @es_params = es_params
    end

    def build
      return @es_params if @query.blank?

      @es_params[:query][:bool][:must][:bool][:should] << { match: { title: @query } }
      @es_params[:query][:bool][:must][:bool][:should] << { match: { name: @query } }

      @es_params
    end
  end
end
