module V1
  class ListsItemPresenter < Yumi::Base
    type 'items'
    attributes :name, :published_at, :created_at, :updated_at
    links :self

    delegate :id, :name, :published_at, :created_at, :updated_at, to: :'object.item'

    def resource_id(o = object)
      o.item_id
    end

    def resource_type(resource)
      resource.item_type.downcase.pluralize
    end
  end
end
