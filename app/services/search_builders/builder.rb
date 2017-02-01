module SearchBuilders
  class Builder
    attr_accessor :search_params

    def initialize(query, filters)
      @query = query
      @filters = filters
      @search_params = base
    end

    def search
      search_params = SearchBuilders::Query.new(@query, search_params).build
      self
    end

    def filter_by_resource_type
      search_params = SearchBuilders::ResourceTypeFilter.new(@filters, search_params).build
      self
    end

    def models
      SearchBuilders::ModelLister.new(@filters).build
    end

    def to_elasticsearch
      [search_params, models]
    end

    private

    def base
      {
        query: {
          bool: {
            must: {
              bool: {
                should: []
              }
            },
            filter: {
              bool: {
                should: {
                  bool: {
                    minimum_should_match: 1,
                    should: []
                  }
                }
              }
            }
          }
        }
      }
    end
  end
end
