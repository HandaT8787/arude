FactoryBot.define do
  factory :rating do
    visit
    category { "景色" }
    score { 3 }
  end
end
