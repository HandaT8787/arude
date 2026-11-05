FactoryBot.define do
  factory :comment do
    user
    post
    body { "コメント" }
  end
end
