class QuerySearch
  def initialize(params)
    @params = params
  end

  def search
    return [] unless @params[:query]

    Elasticsearch::Model.search({
      query: {
        bool: {
          must: [
            bool: {
              should: [
                { match: { title: @params[:query] } },
                { match: { name: @params[:query] } },
              ]
            }
          ]
        }
      }
    }, [Resource, Group, List])
  end
end
