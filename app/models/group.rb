class Group < ApplicationRecord
  has_paper_trail
  acts_as_taggable

  has_many :groups_users
  has_many :users, through: :groups_users
  has_many :lists, as: :owner

  validates :name, presence: true

  def resources
    lists.map(&:resources).flatten.uniq
  end
end
