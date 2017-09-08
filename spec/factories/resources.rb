FactoryGirl.define do
  factory :resource do
    title { Faker::Book.title }
    resource_type { :book }
    short_content { Faker::Hipster.paragraph }
    privacy 'publ'
  end

  factory :book, parent: :resource

  factory :article, parent: :resource do
    resource_type { :article }
  end

  factory :report, parent: :resource do
    resource_type { :report }
  end

  factory :url, parent: :resource do
    resource_type { :url }
  end

  factory :audio, parent: :resource do
    resource_type { :audio }
  end
end
