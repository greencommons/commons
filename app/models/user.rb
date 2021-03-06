class User < ApplicationRecord
  include Indexable

  has_paper_trail
  acts_as_taggable

  mount_uploader :avatar, AvatarUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :networks_users
  has_many :networks, through: :networks_users
  has_many :owned_lists, as: :owner, class_name: List
  has_many :network_owned_lists, through: :networks, source: :lists, class_name: List
  has_many :api_keys

  validates :email, presence: true, uniqueness: true
  validates :first_name, length: { maximum: 255 }
  validates :last_name, length: { maximum: 255 }
  validates :bio, length: { maximum: 500 }

  scope :filter_by_email, ->(email) { where('email ILIKE ?', "%#{email}%") }
  scope :sort_by_email, -> { order('email ASC') }

  settings index: { number_of_shards: 2 } do
    mappings dynamic: true do
      indexes :id, type: 'long'
      indexes :email, analyzer: 'english', type: 'string'
      indexes :first_name, analyzer: 'english', type: 'string'
      indexes :last_name, analyzer: 'english', type: 'string'
      indexes :bio, analyzer: 'english', type: 'string'
      indexes :created_at, type: 'date'
      indexes :updated_at, type: 'date'

      indexes :name_suggest, type: 'completion'
    end
  end

  def all_owned_lists
    List.where(owner_type: 'User', owner_id: id).
      or(List.where(owner_type: 'Network', owner_id: networks.pluck(:id)))
  end

  def as_indexed_json(_options = {})
    json = as_json
    json['name_suggest'] = { input: [first_name ? first_name.split(' ') : nil,
                                     last_name ? last_name.split(' ') : nil,
                                     email].compact.flatten }
    json
  end

  def full_name
    ([first_name, last_name] - ['']).compact.join(' ')
  end
  alias name full_name
end
