FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    name { "テストユーザー" }
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "password123" }
    status { "active" }
    is_admin { false }

    trait :withdrawn do
      status { "withdrawn" }
    end

    trait :admin do
      is_admin { true }
    end

    trait :guest do
      is_guest { true }
    end

  end
end
