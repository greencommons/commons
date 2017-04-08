module SearchBuilders
  SORT_ATTRIBUTES = %w(published_at created_at updated_at).freeze

  class Sorter
    def initialize(sort, es_params)
      @sort = sort
      @attributes = @sort&.split(',')
      @es_params = es_params
    end

    def build
      return @es_params if @sort.blank?

      @attributes.each do |attribute|
        dir = if attribute[0] == '-'
                attribute[0] = ''
                'desc'
              else
                'asc'
              end

        if SORT_ATTRIBUTES.include?(attribute)
          @es_params[:sort].unshift(attribute => { order: dir })
        end
      end

      @es_params
    end
  end
end
