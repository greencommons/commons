FactoryGirl.define do
  factory :list do
    name  { Faker::Lorem.word }
    owner { FactoryGirl.create(:user) }
  end
end
