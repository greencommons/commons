module SearchBuilders
  class Query
    QUERY_KEYS = {
      title: 1,
      name: 1,
      short_content: 1,
      long_content: 1,
      short_description: 1,
      long_description: 1,
      'metadata.publisher': 1,
      'metadata.creators': 1,
      'metadata.isbn': 1,
      tags: 10
    }.freeze

    def initialize(query, es_params)
      @query = query
      @es_params = es_params
    end

    def build
      return @es_params if @query.blank?

      QUERY_KEYS.each do |key, value|
        @es_params[:query][:bool][:must][:bool][:should] << {
          match: { key => { query: @query, boost: value } }
        }
      end

      @es_params
    end
  end
end
