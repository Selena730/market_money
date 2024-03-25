FactoryBot.define do
  factory :market_vendor do
    association :market
    association :vendor
  end
end
