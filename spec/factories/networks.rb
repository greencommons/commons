FactoryGirl.define do
  factory :network do
    name              { Faker::Company.name }
    short_description { Faker::Lorem.sentence }
    long_description  { Faker::Lorem.paragraph }
  end
end
