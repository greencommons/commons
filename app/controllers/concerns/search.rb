module Search
  extend ActiveSupport::Concern

  def search(models: [])
    search = SearchBuilders::Search.new(
      q: params[:q],
      filters: params[:filters]&.to_unsafe_hash,
      sort: params[:sort],
      page: params[:page],
      per: params[:per],
      models: models
    )

    results = search.results_with_relevancy
    data = present_collection(results, search.total_count)

    [data, results]
  end
end
