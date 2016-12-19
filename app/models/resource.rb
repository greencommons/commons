class Resource < ApplicationRecord
  include Elasticsearch::Model
  index_name SearchIndex.index_name(self)

  RESOURCE_TYPES = {
    article: 0,
    book: 1,
    report: 2,
  }.freeze

  has_paper_trail
  acts_as_taggable

  # Warning: since this is an enum (stored as an integer), we need to preserve the original integers
  # each value is associated with. Otherwise the types stored in the database will switch around.
  # See: http://www.justinweiss.com/articles/creating-easy-readable-attributes-with-activerecord-enums/
  enum resource_type: RESOURCE_TYPES

  belongs_to :user, optional: true
  has_and_belongs_to_many :lists

  validates :title, :resource_type, presence: true

  after_commit on: [:create, :update] do
    AddToIndexJob.perform_async(self.class.name, id)
  end

  after_commit on: [:destroy] do
    RemoveFromIndexJob.perform_async(self.class.name, id)
  end
end
