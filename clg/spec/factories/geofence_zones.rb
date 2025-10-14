FactoryBot.define do
  factory :geofence_zone do
    patient { nil }
    name { "MyString" }
    center_latitude { "9.99" }
    center_longitude { "9.99" }
    radius_meters { 1 }
    active { false }
  end
end
