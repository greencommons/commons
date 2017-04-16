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

        results = search.results_with_relevancy
        data = present_collection(results, search.total_count)

        if results.any?
          tags = results.map(&:cached_tags).flatten.compact.uniq
          data[:related] = Suggesters::Tags.new(tags: tags,
                                                except: results,
                                                limit: 6).suggest
        end

        render_json_api data
      end
    end
  end
end
