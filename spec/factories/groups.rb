# frozen_string_literal: true
FactoryGirl.define do
  factory :group do
    name              { Faker::Company.name }
    short_description { Faker::Lorem.sentence }
    long_description  { Faker::Lorem.paragraph }
    url               { Faker::Internet.url }
  end
end
