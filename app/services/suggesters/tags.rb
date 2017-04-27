module Suggesters
  class Tags
    def initialize(tags:, except: [], limit: 10, models: [Group, List, Resource])
      @tags = tags
      @except = [*except]
      @limit = limit
      @models = models
    end

    def suggest
      load_es_params
      return records unless @except.any?

      records.reject do |r|
        @except.map { |e| [e.id, e.class.name] }.include?([r.id, r.class.name])
      end
    end

    private

    def records
      @records ||= Elasticsearch::Model.search(@es_params, @models).records.to_a
    end

    def load_es_params
      @es_params = {
        from: 0,
        size: @limit,
        query: {
          bool: {
            filter: {
              terms: { tags: @tags }
            },
          }
        }
      }
    end
  end
end
