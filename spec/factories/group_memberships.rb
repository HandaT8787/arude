FactoryBot.define do
  factory :group_membership do
    user { nil }
    group { nil }
    role { "MyString" }
  end
end
