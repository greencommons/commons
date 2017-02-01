class SearchController < ApplicationController
  def new
  end

  def show
    skip_authorization

    @query = params[:query]
    @filters = params[:filters] || nil

    if @query
      builder = SearchBuilders::Builder.new(@query, @filters)
      builder = builder.search.filter_by_resource_type

      @results = Elasticsearch::Model.search(*builder.to_elasticsearch).
                 page(params[:page] || 1).per(10)
    else
      @results = []
    end
  end
end
