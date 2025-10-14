class DashboardController < ApplicationController
  def index
    @patients = current_user.patients.includes(:vital_signs, :activities, :geofence_zones)
    @recent_notifications = current_user.notifications.unread.recent.limit(5)
    @total_patients = @patients.count
    @patients_in_safe_zones = @patients.count { |p| p.location_status == "safe" }
    @patients_away = @patients.count { |p| p.location_status == "away" }
    @patients_outside_zones = @patients.count { |p| p.location_status == "outside_zone" }
    @patients_offline = @patients.count { |p| p.location_status == "offline" }
    @critical_alerts = current_user.notifications.unread.by_priority("critical").count

    # Real-time data for dashboard widgets
    @vital_signs_data = []
    @patients.each do |patient|
      latest_vitals = patient.latest_vital_signs
      if latest_vitals
        @vital_signs_data << {
          patient: patient.name,
          patient_id: patient.id,
          heart_rate: latest_vitals.heart_rate,
          blood_pressure: "#{latest_vitals.blood_pressure_systolic}/#{latest_vitals.blood_pressure_diastolic}",
          temperature: latest_vitals.temperature&.round(2),
          status: latest_vitals.status,
          status_color: latest_vitals.status_color,
          recorded_at: latest_vitals.recorded_at
        }
      end
    end

    @recent_activities = Activity.joins(:patient)
                                 .where(patient: @patients)
                                 .recent
                                 .limit(10)
                                 .includes(:patient)
  end
end
