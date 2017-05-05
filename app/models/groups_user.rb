class GroupsUser < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :group, presence: true
  validates :user, presence: true
  validates :admin, inclusion: { in: [true, false] }
  validates :user_id, uniqueness: { scope: :group_id }

  scope :sorted, -> { order(:created_at) }
end
