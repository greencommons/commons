# spec/factories/api_keys.rb
FactoryGirl.define do
  factory :api_key do
    access_key "RandomAccessKey"
    secret_key "RandomSecretKey"
    active true
  end
end
