class Resource < ApplicationRecord

  belongs_to :user

  # Warning: since this is an enum (stored as an integer), order matters. We need to preserve the 
  # order of this array, otherwise all the types stored in the database will switch around.
  # See: http://www.justinweiss.com/articles/creating-easy-readable-attributes-with-activerecord-enums/
  enum resource_type:  [:book, :article, :report, :study]

  validates_presence_of :title, :resource_type
end
