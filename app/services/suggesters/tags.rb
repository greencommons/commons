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
      except_records if @except
      Elasticsearch::Model.search(@es_params, @models).records
    end

    private

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

    def except_records
      @es_params[:query][:bool][:must_not] ||= [
        { terms: { _id: @except.map(&:id) } },
        { terms: { type: @except.map { |e| e.class.name.downcase } } }
      ]
    end
  end
end
