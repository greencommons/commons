class Network < ApplicationRecord
  include Indexable
  include Taggable

  has_paper_trail

  has_many :networks_users
  has_many :users, through: :networks_users
  has_many :owned_lists, as: :owner, class_name: List
  has_many :resources, through: :lists
  has_many :lists_items, as: :item
  has_many :lists, through: :lists_items

  validates :name, presence: true

  settings index: { number_of_shards: 2 } do
    mappings dynamic: true do
      indexes :id, type: 'long'
      indexes :name, analyzer: 'english', type: 'string'
      indexes :short_description, analyzer: 'english', type: 'string'
      indexes :long_description, analyzer: 'english', type: 'string'
      indexes :url, type: 'string'
      indexes :email, analyzer: 'english', type: 'string'
      indexes :tags, fields: { keyword: { ignore_above: 256, type: 'keyword' } }, type: 'text'
      indexes :created_at, type: 'date'
      indexes :published_at, type: 'date'
      indexes :updated_at, type: 'date'

      indexes :name_suggest, type: 'completion'
    end
  end

  def as_indexed_json(_options = {})
    json = as_json
    json['tags'] = json.delete('cached_tags')
    json['name_suggest'] = { input: name.split(' ') }
    json
  end

  def latest_resources(limit: 4)
    resources.sort_by_created_at.distinct.limit(limit)
  end

  def add_admin(user)
    networks_users.new(user: user, admin: true).save
  end

  def add_user(user)
    networks_users.new(user: user).save
  end

  def admin?(user)
    find_member(user).try(:admin) || false
  end

  def find_member(user)
    networks_users.find_by(user: user)
  end

  def admin_count
    networks_users.where(admin: true).count
  end
end
