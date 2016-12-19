class Group < ApplicationRecord
  has_paper_trail
  acts_as_taggable

  has_many :groups_users
  has_many :users, through: :groups_users
  has_many :lists, as: :owner
  has_many :resources, through: :lists

  validates :name, presence: true

  def latest_resources
    resources.sort_by_created_at.limit(4)
  end

  def add_admin(user)
    groups_users.new(user: user, admin: true).save
  end

  def add_user(user)
    groups_users.new(user: user).save
  end

  def admin?(user)
    find_member(user).try(:admin) || false
  end

  def find_member(user)
    groups_users.find_by(user: user)
  end
end
