module Suggesters
  class Lists
    def initialize(query:, except: [], from: 0, limit: 10)
      @query = query
      @except = [*except]
      @from = from
      @limit = limit
    end

    def suggest
      p records
      return records # unless @except.any?

      # records.reject do |r|
      #   @except.map { |e| [e.id, e.class.name] }.include?([r.id, r.class.name])
      # end
    end

    private

    def records
      @records ||= List.search(es_params).records.to_a
    end

    def es_params
      @es_params ||= {
        # from: @from,
        # size: @limit,
        suggest: {
          suggestable_name: {
            prefix: @query,
            completion: {
              field: "suggestable_name"
            }
          }
        }
      }
    end
  end
end
