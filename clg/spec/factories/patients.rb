FactoryBot.define do
  factory :patient do
    name { "MyString" }
    age { 1 }
    gender { "MyString" }
    medical_condition { "MyText" }
    user { nil }
    latitude { "9.99" }
    longitude { "9.99" }
    last_seen_at { "2025-10-04 20:02:20" }
  end
end
