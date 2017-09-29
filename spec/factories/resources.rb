FactoryGirl.define do
  factory :resource do
    title { Faker::Book.title }
    url { 'https://google.com/' }
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

  factory :course, parent: :resource do
    resource_type { :course }
  end

  factory :dataset, parent: :resource do
    resource_type { :dataset }
  end

  factory :image, parent: :resource do
    resource_type { :image }
  end

  factory :syllabus, parent: :resource do
    resource_type { :syllabus }
  end

  factory :video, parent: :resource do
    resource_type { :video }
  end

  factory :profile, parent: :resource do
    resource_type { :profile }
  end
end
