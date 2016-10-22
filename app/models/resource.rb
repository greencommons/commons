class Resource < ApplicationRecord
  has_paper_trail
  # Warning: since this is an enum (stored as an integer), we need to preserve the original integers
  # each value is associated with. Otherwise the types stored in the database will switch around.
  # See: http://www.justinweiss.com/articles/creating-easy-readable-attributes-with-activerecord-enums/
  enum resource_type: {
    article: 0,
    book: 1,
    report: 2
  }

  belongs_to :user, optional: true
  has_and_belongs_to_many :lists

  validates_presence_of :title, :resource_type
end
