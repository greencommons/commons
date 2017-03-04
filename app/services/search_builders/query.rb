# frozen_string_literal: true
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
      @es_params[:query][:bool][:must][:bool][:should] << { match: { content: @query } }
      @es_params[:query][:bool][:must][:bool][:should] << { match: { long_description: @query } }

      @es_params
    end
  end
end
