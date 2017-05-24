class ListsItem < ApplicationRecord
  belongs_to :list
  belongs_to :item, polymorphic: true

  validates :list, presence: true
  validates :item, presence: true
  validates_uniqueness_of :list_id, scope: [:item_id, :item_type]
end
