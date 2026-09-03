FactoryBot.define do
  factory :comment do
    user { nil }
    post { nil }
    body { "MyString" }
    is_checked { false }
    checked_at { "2026-09-03 06:20:43" }
  end
end
