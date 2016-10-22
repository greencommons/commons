FactoryGirl.define do
  factory :resource do
    title          { Faker::Book.title }    
    resource_type  { :book }
  end
end
