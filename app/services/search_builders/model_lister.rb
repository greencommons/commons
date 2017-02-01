module SearchBuilders
  class ModelLister
    MODEL_TYPE_FILTERS = {
      resources: Resource,
      people: User,
      lists: List,
      groups: Group
    }.freeze

    def initialize(filters)
      @filters = filters
    end

    def build
      return MODEL_TYPE_FILTERS.values if @filters&.dig(:model_types)&.empty?

      @filters[:model_types].keys.collect do |model_type|
        if MODEL_TYPE_FILTERS.keys.include?(model_type.to_sym)
          MODEL_TYPE_FILTERS[model_type.to_sym]
        end
      end
    end
  end
end
