# frozen_string_literal: true
FactoryGirl.define do
  factory :resource do
    title { Faker::Book.title }
    resource_type { :book }
    content { Faker::Hipster.paragraph }
    privacy "publ"
  end
end
