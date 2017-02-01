module SearchBuilders
  class Query
    def initialize(query, search_params)
      @query = query
      @search_params = search_params
    end

    def build
      return @search_params unless @query

      @search_params[:query][:bool][:must][:bool][:should] << { match: { title: @query } }
      @search_params[:query][:bool][:must][:bool][:should] << { match: { name: @query } }

      @search_params
    end
  end
end
