FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@toyasoft.com"}
    password { "1234asdfqWer!" }
    point { 10000 }
  end
end
