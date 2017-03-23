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

        render json: Yumi::Presenter.new(url: base_url,
                                         current_url: request.original_url,
                                         resource: search.results_with_relevancy,
                                         presenters_module: ::V1).as_json_api
      end
    end
  end
end
