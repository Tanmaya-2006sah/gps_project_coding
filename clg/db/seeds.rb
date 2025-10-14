# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create demo user
demo_user = User.find_or_create_by!(email: "demo@patientmonitor.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.first_name = "Sarah"
  user.last_name = "Johnson"
  user.phone = "+1-555-0123"
  user.relationship_to_patient = "Daughter"
  user.confirmed_at = Time.current
end

puts "Created demo user: #{demo_user.email}"

# Create sample patients
patients_data = [
  {
    name: "Robert Johnson",
    age: 74,
    gender: "male",
    medical_condition: "Early-stage Alzheimer's disease, mild hypertension",
    latitude: 40.7128,
    longitude: -74.0060,
    last_seen_at: 15.minutes.ago
  },
  {
    name: "Mary Williams",
    age: 68,
    gender: "female",
    medical_condition: "Moderate Alzheimer's disease, diabetes type 2",
    latitude: 40.7589,
    longitude: -73.9851,
    last_seen_at: 2.hours.ago
  },
  {
    name: "James Davis",
    age: 71,
    gender: "male",
    medical_condition: "Mild cognitive impairment, heart condition",
    latitude: 40.7282,
    longitude: -73.7949,
    last_seen_at: 30.minutes.ago
  }
]

patients = []
patients_data.each do |patient_data|
  patient = demo_user.patients.find_or_create_by!(name: patient_data[:name]) do |p|
    p.assign_attributes(patient_data)
  end
  patients << patient
  puts "Created patient: #{patient.name}"
end

# Create geofence zones for patients
patients.each_with_index do |patient, index|
  zones_data = [
    {
      name: "Home Safe Zone",
      center_latitude: patient.latitude + 0.001,
      center_longitude: patient.longitude + 0.001,
      radius_meters: 500,
      active: true
    },
    {
      name: "Neighborhood Area",
      center_latitude: patient.latitude,
      center_longitude: patient.longitude,
      radius_meters: 1000,
      active: true
    }
  ]

  zones_data.each do |zone_data|
    zone = patient.geofence_zones.find_or_create_by!(name: zone_data[:name]) do |z|
      z.assign_attributes(zone_data)
    end
    puts "Created geofence zone: #{zone.name} for #{patient.name}"
  end
end

# Create sample vital signs
patients.each do |patient|
  # Create vital signs for the last 7 days
  7.times do |i|
    recorded_time = i.days.ago + rand(0..23).hours + rand(0..59).minutes

    patient.vital_signs.find_or_create_by!(recorded_at: recorded_time) do |vs|
      vs.heart_rate = rand(60..100) + rand(-10..15)  # Normal range with some variation
      vs.blood_pressure_systolic = rand(110..140) + rand(-5..10)
      vs.blood_pressure_diastolic = rand(70..90) + rand(-5..5)
      vs.temperature = 98.6 + rand(-1.0..1.0).round(1)
    end

    puts "Created vital signs for #{patient.name} at #{recorded_time.strftime('%Y-%m-%d %H:%M')}"
  end
end

# Create sample activities
activity_types = %w[walking sitting lying_down standing eating medication_taken bathroom social_interaction sleeping]

patients.each do |patient|
  # Create activities for the last 3 days
  15.times do |i|
    recorded_time = rand(0..72).hours.ago
    activity_type = activity_types.sample

    descriptions = {
      'walking' => [ "Took a walk in the garden", "Walking to the kitchen", "Morning walk" ],
      'eating' => [ "Had breakfast", "Lunch time", "Evening snack", "Dinner" ],
      'medication_taken' => [ "Took morning medication", "Evening pills", "Blood pressure medication" ],
      'bathroom' => [ "Used bathroom", "Personal care" ],
      'social_interaction' => [ "Talked with visitor", "Video call with family", "Chatted with neighbor" ],
      'sleeping' => [ "Afternoon nap", "Night sleep", "Resting" ]
    }

    activity = patient.activities.create!(
      activity_type: activity_type,
      description: descriptions[activity_type]&.sample || "#{activity_type.humanize} activity",
      recorded_at: recorded_time,
      latitude: patient.latitude + rand(-0.001..0.001),
      longitude: patient.longitude + rand(-0.001..0.001)
    )

    puts "Created activity: #{activity.activity_type} for #{patient.name}"
  end
end

# Create sample notifications
notification_data = [
  {
    title: "Patient Left Safe Zone",
    message: "Robert Johnson has moved outside the designated home safe zone. Last location: Central Park area.",
    notification_type: "geofence_violation",
    priority: "high",
    patient: patients.first,
    read: false,
    created_at: 1.hour.ago
  },
  {
    title: "Abnormal Heart Rate Detected",
    message: "Mary Williams shows elevated heart rate of 120 BPM. Please check on patient.",
    notification_type: "vital_signs_alert",
    priority: "critical",
    patient: patients.second,
    read: false,
    created_at: 30.minutes.ago
  },
  {
    title: "Medication Reminder",
    message: "James Davis hasn't taken his evening medication. Please remind patient.",
    notification_type: "activity_alert",
    priority: "medium",
    patient: patients.last,
    read: true,
    created_at: 2.hours.ago
  },
  {
    title: "System Update",
    message: "Patient monitoring system has been updated with new features for location tracking.",
    notification_type: "system_alert",
    priority: "low",
    patient: nil,
    read: false,
    created_at: 6.hours.ago
  }
]

notification_data.each do |notif_data|
  notification = demo_user.notifications.find_or_create_by!(
    title: notif_data[:title],
    created_at: notif_data[:created_at]
  ) do |n|
    n.assign_attributes(notif_data.except(:created_at))
  end
  puts "Created notification: #{notification.title}"
end

# Create demo caretakers
caretakers_data = [
  {
    email: "dr.smith@hospital.com",
    password: "password123",
    first_name: "John",
    last_name: "Smith",
    phone: "+1-555-0234",
    license_number: "MD123456",
    specialization: "geriatrician",
    years_experience: 15,
    active: true
  },
  {
    email: "dr.johnson@clinic.com",
    password: "password123",
    first_name: "Sarah",
    last_name: "Johnson",
    phone: "+1-555-0345",
    license_number: "NP789012",
    specialization: "nurse",
    years_experience: 8,
    active: true
  },
  {
    email: "dr.williams@medical.com",
    password: "password123",
    first_name: "Michael",
    last_name: "Williams",
    phone: "+1-555-0456",
    license_number: "MD345678",
    specialization: "neurologist",
    years_experience: 20,
    active: true
  }
]

caretakers = []
caretakers_data.each do |caretaker_data|
  caretaker = Caretaker.find_or_create_by!(email: caretaker_data[:email]) do |c|
    c.assign_attributes(caretaker_data)
    c.confirmed_at = Time.current
  end
  caretakers << caretaker
  puts "Created caretaker: Dr. #{caretaker.full_name} (#{caretaker.specialization})"
end

# Assign patients to caretakers
patients.each_with_index do |patient, index|
  # Assign each patient to 1-2 caretakers
  assigned_caretakers = caretakers.sample(rand(1..2))

  assigned_caretakers.each_with_index do |caretaker, caretaker_index|
    patient_caretaker = PatientCaretaker.find_or_create_by!(
      patient: patient,
      caretaker: caretaker
    ) do |pc|
      pc.primary_caretaker = caretaker_index == 0  # First assigned caretaker is primary
      pc.assigned_at = rand(1..30).days.ago
    end

    puts "Assigned #{patient.name} to #{caretaker.display_name}#{' (Primary)' if patient_caretaker.primary_caretaker}"
  end
end

puts "\n✅ Seed data created successfully!"
puts "\nDemo login credentials:"
puts "\n👨‍👩‍👧‍👦 FAMILY MEMBER LOGIN:"
puts "Email: demo@patientmonitor.com"
puts "Password: password123"
puts "\n🏥 HEALTHCARE PROFESSIONAL LOGINS:"
puts "Email: dr.smith@hospital.com (Geriatrician)"
puts "Email: dr.johnson@clinic.com (Nurse)"
puts "Email: dr.williams@medical.com (Neurologist)"
puts "Password: password123 (for all)"
puts "\n🌐 Access the application:"
puts "Family Dashboard: http://localhost:3000"
puts "Healthcare Dashboard: http://localhost:3000/caretakers"
puts "\nYou can now start the Rails server with: rails server"
