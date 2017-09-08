class ListsItem < ApplicationRecord
  belongs_to :list, counter_cache: true
  belongs_to :item, polymorphic: true, counter_cache: true

  validates :list, presence: true
  validates :item, presence: true
  validates(
    :list_id,
    uniqueness: {
      scope: %i(item_id item_type),
      message: lambda do |object, _data|
        "\"#{object.item.name}\" is already in the \"#{object.list.name}\" list."
      end
    }
  )
end
