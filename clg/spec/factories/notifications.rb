FactoryBot.define do
  factory :notification do
    user { nil }
    patient { nil }
    title { "MyString" }
    message { "MyText" }
    notification_type { "MyString" }
    read { false }
    priority { "MyString" }
    created_at { "2025-10-04 20:02:54" }
  end
end
