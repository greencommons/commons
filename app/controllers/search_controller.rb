class SearchController < ApplicationController
  def new
  end

  def show
    skip_authorization

    @query = params[:query]
    @filters = params[:filters]
    @sort = params[:sort]
    @dir = params[:dir]

    if @query
      builder = SearchBuilders::Builder.new(@query, @filters, @sort, @dir)
      builder = builder.search.filter_by_resource_type.sort

      @results = Elasticsearch::Model.search(*builder.to_elasticsearch).
                 page(params[:page] || 1).per(10)
    else
      @results = []
    end
  end
end
