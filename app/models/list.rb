class List < ApplicationRecord
  has_paper_trail
  acts_as_taggable

  belongs_to :owner, polymorphic: true
  has_and_belongs_to_many :resources

  validates :name, presence: true
  validates :owner, presence: true
  validates :owner_type, inclusion: %w(User Group)
end
