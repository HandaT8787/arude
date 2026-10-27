FactoryBot.define do
  factory :group_membership do
    user
    group
    trait :owner do
      role { "owner" }
    end
  end
end
