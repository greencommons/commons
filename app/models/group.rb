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

  def add_admin(user)
    groups_users.create(user: user, admin: true)
  end

  def add_user(user)
    groups_users.create(user: user)
  end

  def is_admin?(user)
    find_member(user).try(:admin) || false
  end

  def find_member(user)
    groups_users.where(user: user).first
  end
end
