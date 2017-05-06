class ListsItem < ApplicationRecord
  belongs_to :list
  belongs_to :item, polymorphic: true

  validates :list, presence: true
  validates :item, presence: true
end
