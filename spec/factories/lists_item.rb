FactoryGirl.define do
  factory :lists_item do
    list { create(:list) }
    item { create(:network) }
  end
end
