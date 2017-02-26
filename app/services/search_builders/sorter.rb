module SearchBuilders
  SORT_OPTIONS = {
    recent: { col: :published_at, dir: :desc },
    oldest: { col: :published_at, dir: :asc }
  }.freeze

  class Sorter
    def initialize(sort, es_params)
      @sort = sort
      @match_sort = SORT_OPTIONS[@sort&.to_sym]
      @es_params = es_params
    end

    def build
      return @es_params if @sort.blank?
      return @es_params unless @match_sort

      @es_params[:sort].unshift(@match_sort[:col] => { order: @match_sort[:dir] })
      @es_params
    end
  end
end
