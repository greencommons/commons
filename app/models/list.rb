class List < ApplicationRecord
  has_paper_trail
  acts_as_taggable

  belongs_to :owner, polymorphic: true
  has_and_belongs_to_many :resources

  validates_presence_of :name
  validates :owner_type, inclusion: ['User', 'Group']
end
