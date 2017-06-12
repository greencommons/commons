module Actions
  class CreateListItems
    def initialize(params, list)
      @data = params.to_unsafe_hash[:data]
      @list = list
      @items = { 'groups' => {}, 'resources' => {} }
      @built_items = []
    end

    def run
      extract_items
      fill_records(Group, 'groups')
      fill_records(Resource, 'resources')

      @items['groups'].each { |_id, group| create_list_item(group) }
      @items['resources'].each { |_id, resource| create_list_item(resource) }

      @built_items
    end

    private

    def create_list_item(hash)
      return unless hash['object']

      @built_items << ListsItem.new(
        list: @list,
        item: hash['object'],
        published_at: hash['object'].published_at,
        note: hash['note']
      )
    end

    def fill_records(klass, type)
      klass.where(id: @items[type].keys).each do |g|
        @items[type][g.id.to_s]['object'] = g
      end
    end

    def extract_items
      @data.each do |o|
        if o['type'] == 'groups'
          @items['groups'][o['id'].to_s] = o
        elsif o['type'] == 'resources'
          @items['resources'][o['id'].to_s] = o
        end
      end
    end
  end
end
