module SearchBuilders
  class DateFilter
    def initialize(filters, es_params)
      @filters = filters || {}
      @es_params = es_params
    end

    def build
      return @es_params unless @filters &&
                               @filters[:start].present? &&
                               @filters[:end].present?

      filter_by_date
      @es_params
    end

    private

    def filter_by_date
      @es_params[:query][:bool][:filter][:bool][:should][:bool][:should] << {
        range: {
          published_at: {
            lte: Time.at(@filters[:end].to_i).strftime('%Y-%m-%dT%H:%M:%S'),
            gte: Time.at(@filters[:start].to_i).strftime('%Y-%m-%dT%H:%M:%S')
          }
        }
      }
    end
  end
end
