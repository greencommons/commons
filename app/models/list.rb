class List < ApplicationRecord
  include Indexable
  include Taggable
  include Privacy

  has_paper_trail

  belongs_to :owner, polymorphic: true
  has_many :lists_items
  has_many :resources, through: :lists_items, source: :item,
                       source_type: 'Resource'
  has_many :groups, through: :lists_items, source: :item,
                    source_type: 'Group'

  validates :name, presence: true
  validates :owner, presence: true
  validates :owner_type, inclusion: %w(User Group)

  settings index: { number_of_shards: 2 } do
    mappings dynamic: 'false' do
      indexes :id, type: 'long'
      indexes :name, analyzer: 'english', type: 'string'
      indexes :description, analyzer: 'english', type: 'string'
      indexes :owner_id, type: 'long'
      indexes :owner_type, fields: { keyword: { ignore_above: 256, type: 'keyword' } }, type: 'text'
      indexes :privacy, fields: { keyword: { ignore_above: 256, type: 'keyword' } }, type: 'text'
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
end
