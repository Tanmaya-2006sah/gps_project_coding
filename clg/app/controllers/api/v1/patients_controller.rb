class Api::V1::PatientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_patient, only: [ :show, :location, :vital_signs, :activities ]

  def show
    render json: {
      id: @patient.id,
      name: @patient.name,
      age: @patient.age,
      gender: @patient.gender,
      latitude: @patient.latitude,
      longitude: @patient.longitude,
      location_status: @patient.location_status,
      last_seen_at: @patient.last_seen_at,
      medical_conditions: @patient.medical_conditions
    }
  end

  def location
    render json: {
      patient_id: @patient.id,
      latitude: @patient.latitude,
      longitude: @patient.longitude,
      location_status: @patient.location_status,
      last_seen_at: @patient.last_seen_at,
      time_ago: @patient.last_seen_at ? time_ago_in_words(@patient.last_seen_at) : "Never",
      is_in_geofence: @patient.is_in_geofence?
    }
  end

  def locations
    # Get locations for all of the current user's patients
    locations_data = current_user.patients.map do |patient|
      {
        patient_id: patient.id,
        name: patient.name,
        latitude: patient.latitude,
        longitude: patient.longitude,
        status: patient.location_status,
        last_seen_at: patient.last_seen_at,
        time_ago: patient.last_seen_at ? time_ago_in_words(patient.last_seen_at) : "Never"
      }
    end

    render json: locations_data
  end

  def vital_signs
    latest_vitals = @patient.vital_signs.order(recorded_at: :desc).limit(10)

    vitals_data = latest_vitals.map do |vital|
      {
        id: vital.id,
        heart_rate: vital.heart_rate,
        blood_pressure_systolic: vital.blood_pressure_systolic,
        blood_pressure_diastolic: vital.blood_pressure_diastolic,
        temperature: vital.temperature,
        status: vital.status,
        recorded_at: vital.recorded_at,
        time_ago: time_ago_in_words(vital.recorded_at)
      }
    end

    render json: vitals_data
  end

  def activities
    recent_activities = @patient.activities.order(recorded_at: :desc).limit(20)

    activities_data = recent_activities.map do |activity|
      {
        id: activity.id,
        activity_type: activity.activity_type,
        description: activity.description,
        latitude: activity.latitude,
        longitude: activity.longitude,
        recorded_at: activity.recorded_at,
        time_ago: time_ago_in_words(activity.recorded_at)
      }
    end

    render json: activities_data
  end

  private

  def set_patient
    @patient = current_user.patients.find(params[:id])
  end
end
