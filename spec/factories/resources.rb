FactoryGirl.define do
  factory :resource do
    title { Faker::Book.title }    
    user  { FactoryGirl.create(:user) }
  end
end
