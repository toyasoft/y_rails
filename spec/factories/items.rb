FactoryBot.define do
  factory :item do
    user { create(:user) }
    sequence(:name) { |n| "商品#{n}" }
    point { 1000 }
    user_id { user.id }
  end
end
