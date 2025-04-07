FactoryBot.define do
  factory :corporate_profile do
    business_name { "MyString" }
    description { "MyText" }
    business_hours { "MyString" }
    about { "MyText" }
    logo { "MyString" }
    address { "MyText" }
    user { nil }
  end
end
