module SearchBuilders
  class ResourceTypeFilter
    RESOURCE_TYPE_FILTERS = {
      books: 'book',
      articles: 'article',
      reports: 'report'
    }.freeze

    def initialize(filters, es_params)
      @filters = filters
      @es_params = es_params
    end

    def build
      return @es_params unless @filters&.dig(:resource_types)&.any?

      ignore_irrelevant_documents
      filter_by_resource_type
      @es_params
    end

    private

    def ignore_irrelevant_documents
      @es_params[:query][:bool][:filter][:bool][:should][:bool][:should] << {
        bool: {
          must_not: {
            exists: { field: 'resource_type' }
          }
        }
      }
    end

    def filter_by_resource_type
      @filters[:resource_types].keys.each do |resource_type|
        next unless RESOURCE_TYPE_FILTERS.keys.include?(resource_type.to_sym)
        @es_params[:query][:bool][:filter][:bool][:should][:bool][:should] << {
          term: { resource_type: RESOURCE_TYPE_FILTERS[resource_type.to_sym] }
        }
      end
    end
  end
end
