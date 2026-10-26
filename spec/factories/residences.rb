FactoryBot.define do
  factory :residence do
    user
    prefecture { "東京都" }
    city { "江東区" }
    started_on { Date.new(2026, 9, 4) }
    ended_on { nil }
  end
end
