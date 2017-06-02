module Suggesters
  class Lists
    def initialize(query:, only: [], except: [])
      @query = query
      @only = only.map { |e| [e.id, e.class.name] }
      @except = [*except].compact.map { |e| [e.id, e.class.name] }
    end

    def suggest
      @records ||= format_records
    end

    private

    def format_records
      return [] unless es_records['suggest'] && es_records['suggest']['list_suggest'].any?

      formatted_records = es_records['suggest']['list_suggest'].first['options'].map do |l|
        { id: l['_source']['id'], name: l['_source']['name'] }
      end
      return formatted_records unless @except.any? || @only.any?

      formatted_records.reject do |r|
        (@only.any? && !@only.include?([r[:id], 'List'])) ||
          (@except.any? && @except.include?([r[:id], 'List']))
      end
    end

    def es_records
      @es_records ||= List.__elasticsearch__.client.search(index: List.index_name,
                                                           body: es_params)
    end

    def es_params
      @es_params ||= {
        suggest: {
          list_suggest: {
            text: @query,
            completion: {
              field: 'name_suggest',
              fuzzy: {
                fuzziness: 2
              },
            }
          }
        }
      }
    end
  end
end
