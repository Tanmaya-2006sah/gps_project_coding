FactoryBot.define do
  factory :activity do
    patient { nil }
    activity_type { "MyString" }
    description { "MyText" }
    recorded_at { "2025-10-04 20:03:04" }
    latitude { "9.99" }
    longitude { "9.99" }
  end
end
