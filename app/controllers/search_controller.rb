class SearchController < ApplicationController
  def new
    @results = params[:query].present? ? Resource.search(params[:query]) : []
  end
end
