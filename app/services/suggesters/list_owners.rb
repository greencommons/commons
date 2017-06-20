module Suggesters
  class ListOwners
    def initialize(query:)
      @query = query
    end

    def suggest
      @records ||= format_records(User) + format_records(Network)
    end

    private

    def format_records(klass)
      records = es_records(klass)
      return [] unless records['suggest'] && records['suggest']['owner_suggest'].any?

      records['suggest']['owner_suggest'].first['options'].map do |l|
        {
          id: "#{klass}:#{l['_source']['id']}",
          name: "#{l['_source']['name'] || user_name(l)} (#{klass})"
        }
      end
    end

    def user_name(l)
      "#{l['_source']['first_name']} #{l['_source']['last_name']}, #{l['_source']['email']}".strip
    end

    def es_records(klass)
      @es_records = klass.__elasticsearch__.client.search(index: klass.index_name,
                                                          body: es_params)
    end

    def es_params
      @es_params ||= {
        suggest: {
          owner_suggest: {
            text: @query,
            completion: {
              field: 'name_suggest'
            }
          }
        }
      }
    end
  end
end
