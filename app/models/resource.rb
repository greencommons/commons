class Resource < ApplicationRecord
  include Indexable
  include Taggable

  RESOURCE_TYPES = {
    article: 0,
    book: 1,
    report: 2,
    url: 3
  }.freeze

  RESOURCE_PRIVACY_SETTINGS = {
    priv: 0,
    publ: 1
  }.freeze

  has_paper_trail

  # Warning: since this is an enum (stored as an integer), we need to preserve the original integers
  # each value is associated with. Otherwise the types stored in the database will switch around.
  # See: http://www.justinweiss.com/articles/creating-easy-readable-attributes-with-activerecord-enums/
  enum resource_type: RESOURCE_TYPES
  enum privacy: RESOURCE_PRIVACY_SETTINGS

  belongs_to :user, optional: true
  has_and_belongs_to_many :lists

  validates :title, :resource_type, presence: true
  validates :url, length: { maximum: 255 }

  scope :sort_by_created_at, -> { order('created_at DESC') }

  def excerpt
    return content unless content.is_a?(String)
    content.truncate(800)
  end

  def creators
    metadata['creators']
  end

  def publisher
    metadata['publisher']
  end
end
