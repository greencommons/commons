module SearchBuilders
  SORT_OPTIONS = {
    date: :created_at
  }.freeze

  class Sorter
    def initialize(sort, dir, es_params)
      @sort = sort
      @dir = dir
      @match_sort = SORT_OPTIONS[@sort&.downcase&.to_sym]
      @es_params = es_params
    end

    def build
      return @es_params if @sort.blank? || @dir.blank?
      return @es_params unless @match_sort

      @es_params[:sort].unshift(@match_sort => { order: @dir })
      @es_params
    end
  end
end
