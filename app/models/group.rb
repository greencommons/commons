class Group < ApplicationRecord
  has_paper_trail
  acts_as_taggable

  has_and_belongs_to_many :users
  has_many :lists, as: :owner

  validates_presence_of :name

  def resources
    self.lists.map(&:resources).flatten.uniq
  end
end
