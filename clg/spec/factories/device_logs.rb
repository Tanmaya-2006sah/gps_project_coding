FactoryBot.define do
  factory :device_log do
    patient { nil }
    device_type { "MyString" }
    device_id { "MyString" }
    event_type { "MyString" }
    event_data { "MyText" }
    latitude { "9.99" }
    longitude { "9.99" }
    battery_level { 1 }
    signal_strength { 1 }
    recorded_at { "2025-10-04 20:44:06" }
  end
end
