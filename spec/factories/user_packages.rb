FactoryBot.define do
  factory :user_package do
    user { nil }
    package { nil }
    listings_consumed { 1 }
    status { 1 }
  end
end
