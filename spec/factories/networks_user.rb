FactoryGirl.define do
  factory :networks_user do
    network { create(:network) }
    user { create(:user) }
  end
end
