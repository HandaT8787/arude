FactoryBot.define do
  factory :rating do
    user { nil }
    post { nil }
    category { "MyString" }
    score { 1 }
  end
end
