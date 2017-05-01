class SearchController < ApplicationController
  def new
  end

  def show
    skip_authorization
    set_query_params

    search = SearchBuilders::Search.new(
      q: @query,
      filters: @filters,
      sort: @sort,
      page: @page,
      per: @per
    )

    @results = search.results
    @total_count = search.total_count

    if @results.any?
      tags = @results.records.map(&:cached_tags).flatten.compact.uniq
      @suggestions = Suggesters::Tags.new(tags: tags,
                                          except: @results.records,
                                          limit: 6).suggest
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def set_query_params
    @query = params[:query]
    @filters = params[:filters]&.to_unsafe_hash
    @sort = params[:sort]
    @page = params[:page]
    @per = params[:per]
  end
end
