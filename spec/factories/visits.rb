FactoryBot.define do
  factory :visit do
    user { nil }
    post { nil }
    impression { "MyText" }
    visited_at { "2026-09-03 06:14:55" }
  end
end
