module SearchBuilders
  class DateFilter
    def initialize(filters, es_params)
      @filters = filters || {}
      @es_params = es_params
    end

    def build
      return @es_params unless @filters[:start] && @filters[:end]

      @es_params[:query][:bool][:filter][:bool][:should][:bool][:should] << {
        range: {
          published_at: {
            gte: Time.parse(@filters[:start]).to_i,
            lte: Time.parse(@filters[:end]).to_i
          }
        }
      }

      @es_params
    end
  end
end
