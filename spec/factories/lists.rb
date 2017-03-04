# frozen_string_literal: true
FactoryGirl.define do
  factory :list do
    name  { Faker::Lorem.word }
    owner { create(:user) }
  end
end
