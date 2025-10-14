class Api::V1::VitalsController < ApplicationController
  before_action :authenticate_user!

  def latest
    # Get latest vital signs for all of the current user's patients
    vital_signs_data = current_user.patients.includes(:vital_signs).map do |patient|
      latest_vitals = patient.vital_signs.order(recorded_at: :desc).first

      if latest_vitals
        {
          patient_id: patient.id,
          patient_name: patient.name,
          heart_rate: latest_vitals.heart_rate,
          blood_pressure_systolic: latest_vitals.blood_pressure_systolic,
          blood_pressure_diastolic: latest_vitals.blood_pressure_diastolic,
          temperature: latest_vitals.temperature,
          status: latest_vitals.status,
          status_color: latest_vitals.status_color,
          recorded_at: latest_vitals.recorded_at,
          time_ago: time_ago_in_words(latest_vitals.recorded_at)
        }
      end
    end.compact

    render json: vital_signs_data
  end
end
