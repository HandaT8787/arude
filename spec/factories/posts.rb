FactoryBot.define do
  factory :post do
    user { nil }
    group { nil }
    title { "MyString" }
    description { "MyText" }
    category { "MyString" }
    congestion { "MyString" }
    price { 1 }
    caution { "MyText" }
    latitude { 1.5 }
    longitude { 1.5 }
    prefecture { "MyString" }
    city { "MyString" }
  end
end
