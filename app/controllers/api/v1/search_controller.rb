module Api
  module V1
    class SearchController < ApiController
      skip_before_action :validate_auth_scheme, only: %i(show)
      skip_before_action :authenticate_client, only: %i(show)

      def show
        data, results = search

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
