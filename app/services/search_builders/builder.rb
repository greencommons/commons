module SearchBuilders
  class Builder
    attr_accessor :es_params

    def initialize(query: nil, filters: {}, sort: nil)
      @query = query
      @filters = filters
      @sort = sort
      @es_params = base
    end

    def search
      @es_params = SearchBuilders::Query.new(@query, @es_params).build
      self
    end

    def filter_by_resource_type
      @es_params = SearchBuilders::ResourceTypeFilter.new(@filters, @es_params).build
      self
    end

    def sort
      @es_params = SearchBuilders::Sorter.new(@sort, @es_params).build
      self
    end

    def models
      SearchBuilders::ModelLister.new(@filters).build
    end

    def to_elasticsearch
      [@es_params, models]
    end

    private

    def base
      {
        sort: ['_score'],
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
