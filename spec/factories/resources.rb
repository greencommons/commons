FactoryGirl.define do
  factory :resource do
    title { Faker::Book.title }
    resource_type { :book }
    short_content { Faker::Hipster.paragraph }
    privacy 'publ'
  end
end
