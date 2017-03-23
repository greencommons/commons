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

        render json: present(search.results_with_relevancy)
      end
    end
  end
end
