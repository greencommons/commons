# frozen_string_literal: true
FactoryGirl.define do
  factory :groups_user do
    group { create(:group) }
    user  { create(:user) }
  end
end
