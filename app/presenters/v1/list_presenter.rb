module V1
  class ListPresenter < Yumi::Base
    type 'list'

    attributes :name, :description, :published_at, :resources_count,
               :created_at, :updated_at
    links :self
    has_many :lists_items

    def resources_count
      object.resources.count
    end
  end
end
