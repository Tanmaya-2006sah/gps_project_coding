class Api::V1::DashboardController < ApplicationController
  before_action :authenticate_user!

  def stats
    patients = current_user.patients.includes(:vital_signs, :geofence_zones, :activities, :notifications)

    stats = {
      total_patients: patients.count,
      patients_in_safe_zones: patients.select { |p| p.location_status == "safe" }.count,
      patients_away: patients.select { |p| p.location_status == "away" }.count,
      patients_outside_zones: patients.select { |p| p.location_status == "outside_zone" }.count,
      patients_offline: patients.select { |p| p.location_status == "offline" }.count,
      unread_notifications: current_user.unread_notifications_count,
      critical_alerts: current_user.notifications.where(priority: [ "high", "critical" ], read: false).count,
      last_updated: Time.current
    }

    render json: stats
  end
end
