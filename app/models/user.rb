class User < ApplicationRecord
  has_paper_trail
  acts_as_taggable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :groups_users
  has_many :groups, through: :groups_users
  has_many :lists, as: :owner

  scope :filter_by_email, ->(email) { where('email ILIKE ?', "%#{email}%") }
  scope :sort_by_email, -> { order('email ASC') }
end
