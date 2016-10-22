class Group < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :lists, as: :owner

  validates_presence_of :name
end
