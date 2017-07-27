module SearchBuilders
  class ResourceTypeFilter
    RESOURCE_TYPE_FILTERS = {
      books: 'book',
      articles: 'article',
      reports: 'report',
      urls: 'url',
      audios: 'audio',
      courses: 'course',
      datasets: 'dataset',
      images: 'image',
      syllabuses: 'syllabus',
      videos: 'video',
      profiles: 'profile'
    }.freeze

    def initialize(filters, es_params)
      @filters = filters || {}
      @es_params = es_params
    end

    def build
      return @es_params unless values.any?

      ignore_irrelevant_documents
      filter_by_resource_type
      @es_params
    end

    private

    def ignore_irrelevant_documents
      @es_params[:query][:bool][:filter][:bool][:should][:bool][:should] << {
        bool: {
          must_not: {
            exists: { field: 'resource_type' }
          }
        }
      }
    end

    def filter_by_resource_type
      types = values.map { |v| RESOURCE_TYPE_FILTERS[v.to_sym] }.compact
      @es_params[:query][:bool][:filter][:bool][:should][:bool][:should] << {
        terms: { resource_type: types }
      }
    end

    def values
      @values ||= if @filters[:resource_types].is_a?(String)
                    @filters[:resource_types].split(',')
                  else
                    @filters[:resource_types]&.keys || []
                  end
    end
  end
end
