FactoryBot.define do
  factory :report do
    user { nil }
    comment { nil }
    reason { "MyText" }
  end
end
