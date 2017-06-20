module Actions
  class CreateListItems
    def initialize(params, list)
      @data = params.to_unsafe_hash[:data]
      @list = list
      @items = { 'networks' => {}, 'resources' => {} }
      @built_items = []
    end

    def run
      extract_items
      fill_records(Network, 'networks')
      fill_records(Resource, 'resources')

      @items['networks'].each { |_id, network| create_list_item(network) }
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
        if o['type'] == 'networks'
          @items['networks'][o['id'].to_s] = o
        elsif o['type'] == 'resources'
          @items['resources'][o['id'].to_s] = o
        end
      end
    end
  end
end
