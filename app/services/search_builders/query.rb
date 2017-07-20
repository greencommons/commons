module SearchBuilders
  class Query
    QUERY_KEYS = %i{
      title
      name
      short_content
      long_content
      short_description
      long_description
      metadata.publisher
      metadata.creators
      metadata.isbn
    }.freeze

    def initialize(query, es_params)
      @query = query
      @es_params = es_params
    end

    def build
      return @es_params if @query.blank?

      QUERY_KEYS.each do |key|
        @es_params[:query][:bool][:must][:bool][:should] << { match: { key => @query } }
      end

      @es_params
    end
  end
end
