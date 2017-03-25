module Api
  module V1
    class SearchController < ApiController
      def show
        search = SearchBuilders::Search.new(
          q: params[:q],
          filters: params[:filters]&.to_unsafe_hash,
          sort: params[:sort],
          page: params[:page],
          per: params[:per]
        )

        render_json_api present_collection(search.results_with_relevancy, search.total_count)
      end
    end
  end
end
