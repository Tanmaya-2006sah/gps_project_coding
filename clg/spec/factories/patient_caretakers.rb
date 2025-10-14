FactoryBot.define do
  factory :patient_caretaker do
    patient { nil }
    caretaker { nil }
    assigned_at { "2025-10-04 20:44:14" }
    primary_caretaker { false }
    notes { "MyText" }
  end
end
