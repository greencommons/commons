class SearchController < ApplicationController
  def new
  end

  def show
    skip_authorization
    set_search_variables

    if @query
      builder = SearchBuilders::Builder.new(
        query: @query,
        filters: @filters,
        sort: @sort,
      ).search.filter_by_resource_type.sort

      @results = Elasticsearch::Model.search(*builder.to_elasticsearch).
                 page(params[:page] || 1).per(10)
    else
      @results = []
    end

    if @results.any?
      tags = @results.records.map(&:cached_tags).flatten.compact.uniq
      @suggestions = Suggesters::Tags.new(tags: tags,
                                          except: @results.records,
                                          limit: 6).suggest
    end
  end

  private

  def set_search_variables
    @query = params[:query]
    @filters = params[:filters]&.to_unsafe_hash
    @sort = params[:sort]
    @dir = params[:dir]
  end
end
