class Resource < ApplicationRecord
  include Indexable
  include Taggable
  include Privacy

  RESOURCE_TYPES = {
    article: 0,
    book: 1,
    report: 2,
    url: 3,
    audio: 4,
    course: 5,
    dataset: 6,
    image: 7,
    syllabus: 8,
    video: 9,
    profile: 10
  }.freeze

  has_paper_trail

  # Warning: since this is an enum (stored as an integer), we need to preserve the original integers
  # each value is associated with. Otherwise the types stored in the database will switch around.
  # See: http://www.justinweiss.com/articles/creating-easy-readable-attributes-with-activerecord-enums/
  enum resource_type: RESOURCE_TYPES

  belongs_to :user, optional: true
  has_many :lists_items, as: :item
  has_many :lists, through: :lists_items

  validates :title, :resource_type, presence: true
  validates :url, length: { maximum: 255 }

  scope :sort_by_created_at, -> { order('created_at DESC') }

  RESOURCE_TYPES.keys.each do |type|
    scope type.to_s.pluralize, -> { where(resource_type: type) }
  end

  def name
    title
  end

  def excerpt
    return short_content unless short_content.is_a?(String)
    short_content.truncate(500)
  end

  def creators
    metadata['creators']
  end

  def publisher
    metadata['publisher']
  end
end
