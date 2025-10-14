FactoryBot.define do
  factory :vital_sign do
    patient { nil }
    heart_rate { 1 }
    blood_pressure_systolic { 1 }
    blood_pressure_diastolic { 1 }
    temperature { "9.99" }
    recorded_at { "2025-10-04 20:02:34" }
  end
end
