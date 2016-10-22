FactoryGirl.define do
  factory :list do
    owner { FactoryGirl.create(:user) }    
  end
end
