FactoryBot.define do
  factory :visit do
    user
    post
    visited_at { Time.current }
  end
end
