class NetworksUser < ApplicationRecord
  belongs_to :network
  belongs_to :user

  validates :network, presence: true
  validates :user, presence: true
  validates :admin, inclusion: { in: [true, false] }
  validates :user_id, uniqueness: { scope: :network_id }

  scope :sorted, -> { order(:created_at) }
end
