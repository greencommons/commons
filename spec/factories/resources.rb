FactoryGirl.define do
  factory :resource do
    title          { Faker::Book.title }    
    resource_type  { 'book'.to_sym }
    user           { FactoryGirl.create(:user) }
  end
end
