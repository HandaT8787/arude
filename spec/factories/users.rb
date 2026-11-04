FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    name { "テストユーザー" }
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "password123" }
    status { "active" }
    
    trait :withdrawn do
      status { "withdrawn" }
    end
  end
end
