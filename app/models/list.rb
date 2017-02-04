class List < ApplicationRecord
  include Indexable
  include Taggable

  has_paper_trail

  belongs_to :owner, polymorphic: true
  has_and_belongs_to_many :resources

  validates :name, presence: true
  validates :owner, presence: true
  validates :owner_type, inclusion: %w(User Group)
end
