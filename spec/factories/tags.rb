FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "tag#{n}" }
    tag_type { "feature" }

    trait :time do
      tag_type { "time" }
    end
  end
end
