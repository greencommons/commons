FactoryGirl.define do
  factory :groups_user do
    group { create(:group) }
    user  { create(:user) }
  end
end
