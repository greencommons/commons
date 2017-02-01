module SearchBuilders
  class Sorter
    def initialize(sort, dir, search_params)
      @sort = sort
      @dir = dir
      @search_params = search_params
    end

    def build
      return @search_params if @sort.blank? || @dir.blank?
      return @search_params if @sort == 'SCORE'

      @search_params[:sort].unshift(created_at: { order: @dir })

      @search_params
    end
  end
end
