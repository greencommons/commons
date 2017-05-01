class User < ApplicationRecord
  has_paper_trail
  acts_as_taggable

  mount_uploader :avatar, AvatarUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :groups_users
  has_many :groups, through: :groups_users
  has_many :lists, as: :owner

  validates :email, presence: true, uniqueness: true
  validates :first_name, length: { maximum: 255 }
  validates :last_name, length: { maximum: 255 }
  validates :bio, length: { maximum: 500 }

  scope :filter_by_email, ->(email) { where('email ILIKE ?', "%#{email}%") }
  scope :sort_by_email, -> { order('email ASC') }

  def full_name
    ([first_name, last_name] - ['']).compact.join(' ')
  end
end
