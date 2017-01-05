class SearchController < ApplicationController
  def new
    skip_authorization
    @results = params[:query].present? ? Resource.search(params[:query]) : []
  end
end
