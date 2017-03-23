module SearchBuilders
  class Search
    def initialize(q: nil, filters: nil, sort: nil, page: nil, per: nil)
      @query = q
      @filters = filters
      @sort = sort
      @page = page
      @per = per
    end

    def results
      @results ||= Elasticsearch::Model.search(*search_builder.to_elasticsearch).
                   page(@page || 1).per(@per || 10)
    end

    def results_with_relevancy
      @results_with_relevancy ||= lambda do
        array = []
        results.records.each_with_hit do |result, hit|
          result.relevancy = hit._score
          array << result
        end
        array
      end.call
    end

    def total_count
      @total_count ||= results.results.total
    end

    private

    def search_builder
      @builder ||= SearchBuilders::Builder.new(
        query: @query,
        filters: @filters,
        sort: @sort,
      ).search.filter_by_resource_type.sort
    end
  end
end
