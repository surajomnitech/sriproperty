FactoryBot.define do
  factory :phone_number do
    number { "MyString" }
    verified { false }
    primary { false }
    verification_code { "MyString" }
    code_expiry { "2025-03-21 16:51:47" }
    verification_attempts { 1 }
    user { nil }
  end
end
