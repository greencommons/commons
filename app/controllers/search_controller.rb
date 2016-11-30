class SearchController < ApplicationController
  def new
    @results = Resource.search(params[:query])
  end
end
