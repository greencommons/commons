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
      tags: 1
    }.freeze

    def initialize(query, es_params)
      @query = query
      @es_params = es_params
    end

    def build
      return @es_params if @query.blank?

      if @query[0] == '#'
        @es_params[:query][:bool][:filter][:bool][:must] << {
          terms: {
            tags: @query[1..-1].split(' ')
          }
        }
      else
        QUERY_KEYS.each do |key, value|
          @es_params[:query][:bool][:must][:bool][:should] << {
            match: { key => { query: @query, boost: value } }
          }
        end
      end

      @es_params
    end
  end
end
