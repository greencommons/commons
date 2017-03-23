class SearchController < ApplicationController
  def new
  end

  def show
    skip_authorization

    search = SearchBuilders::Search.new(
      q: params[:q],
      filters: params[:filters]&.to_unsafe_hash,
      sort: params[:sort],
      page: params[:page],
      per: params[:per]
    )

    @results = search.results
    @total_count = search.total_count

    if @results.any?
      tags = @results.records.map(&:cached_tags).flatten.compact.uniq
      @suggestions = Suggesters::Tags.new(tags: tags,
                                          except: @results.records,
                                          limit: 6).suggest
    end
  end
end
