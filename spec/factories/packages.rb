FactoryBot.define do
  factory :package do
    name { "MyString" }
    free_listings_count { 1 }
    max_photos_per_listing { 1 }
    is_default { false }
    status { 1 }
  end
end
