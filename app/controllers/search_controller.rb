class SearchController < ApplicationController
  def new
  end

  def show
    skip_authorization
    @results = QuerySearch.new(params).search
  end
end
