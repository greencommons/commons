class SearchController < ApplicationController
  def new
  end

  def show
    skip_authorization

    @results = if params[:query].present?
      Elasticsearch::Model.search(params[:query], [Resource, Group, List])
    else
      []
    end
  end
end
