class List < ApplicationRecord
  include Indexable
  include Taggable
  include Privacy

  has_paper_trail

  belongs_to :owner, polymorphic: true
  has_many :lists_items
  has_many :resources, :through => :lists_items, :source => :item,
    :source_type => 'Resource'
  has_many :groups, :through => :lists_items, :source => :item,
    :source_type => 'Group'

  validates :name, presence: true
  validates :owner, presence: true
  validates :owner_type, inclusion: %w(User Group)
end
