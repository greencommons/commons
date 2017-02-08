class Group < ApplicationRecord
  include Indexable
  include Taggable

  has_paper_trail

  has_many :groups_users
  has_many :users, through: :groups_users
  has_many :lists, as: :owner
  has_many :resources, through: :lists

  validates :name, presence: true

  def latest_resources(limit: 4)
    resources.sort_by_created_at.distinct.limit(limit)
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

  def admin_count
    groups_users.where(admin: true).count
  end
end
