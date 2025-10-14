# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_04_153100) do
  create_table "activities", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.string "activity_type"
    t.text "description"
    t.datetime "recorded_at"
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_activities_on_patient_id"
  end

  create_table "caretakers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "license_number"
    t.string "specialization"
    t.integer "years_experience"
    t.boolean "active"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.boolean "terms_accepted"
    t.index ["email"], name: "index_caretakers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_caretakers_on_reset_password_token", unique: true
  end

  create_table "device_logs", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.string "device_type"
    t.string "device_id"
    t.string "event_type"
    t.text "event_data"
    t.decimal "latitude"
    t.decimal "longitude"
    t.integer "battery_level"
    t.integer "signal_strength"
    t.datetime "recorded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_device_logs_on_patient_id"
  end

  create_table "geofence_zones", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.string "name"
    t.decimal "center_latitude"
    t.decimal "center_longitude"
    t.integer "radius_meters"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_geofence_zones_on_patient_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "patient_id"
    t.string "title"
    t.text "message"
    t.string "notification_type"
    t.boolean "read", default: false
    t.string "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_type"], name: "index_notifications_on_notification_type"
    t.index ["patient_id"], name: "index_notifications_on_patient_id"
    t.index ["priority"], name: "index_notifications_on_priority"
    t.index ["read"], name: "index_notifications_on_read"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "patient_caretakers", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "caretaker_id", null: false
    t.datetime "assigned_at"
    t.boolean "primary_caretaker"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["caretaker_id"], name: "index_patient_caretakers_on_caretaker_id"
    t.index ["patient_id"], name: "index_patient_caretakers_on_patient_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.string "gender"
    t.text "medical_condition"
    t.integer "user_id", null: false
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "last_seen_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_patients_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.string "relationship_to_patient"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vital_signs", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.integer "heart_rate"
    t.integer "blood_pressure_systolic"
    t.integer "blood_pressure_diastolic"
    t.decimal "temperature"
    t.datetime "recorded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id"], name: "index_vital_signs_on_patient_id"
  end

  add_foreign_key "activities", "patients"
  add_foreign_key "device_logs", "patients"
  add_foreign_key "geofence_zones", "patients"
  add_foreign_key "notifications", "patients"
  add_foreign_key "notifications", "users"
  add_foreign_key "patient_caretakers", "caretakers"
  add_foreign_key "patient_caretakers", "patients"
  add_foreign_key "patients", "users"
  add_foreign_key "vital_signs", "patients"
end
