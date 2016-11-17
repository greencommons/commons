FactoryGirl.define do
  factory :list do
    name  { Faker::Lorem.word }
    owner { create(:user) }
  end
end
