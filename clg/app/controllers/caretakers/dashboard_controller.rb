class Caretakers::DashboardController < Caretakers::ApplicationController
  layout "caretaker_dashboard"

  def index
    # Debug current_caretaker
    Rails.logger.debug "Current caretaker class: #{current_caretaker.class}"
    Rails.logger.debug "Current caretaker: #{current_caretaker.inspect}"

    unless current_caretaker.is_a?(Caretaker)
      Rails.logger.error "current_caretaker is not a Caretaker object: #{current_caretaker.class}"
      redirect_to new_caretaker_session_path, alert: "Please sign in again."
      return
    end

    @patients = current_caretaker.patients
                               .includes(:vital_signs, :activities, :geofence_zones, :device_logs, :patient_caretakers)

    # Dashboard statistics
    @total_patients = @patients.count
    @primary_patients = current_caretaker.primary_patients_count
    @patients_with_alerts = current_caretaker.patients_needing_attention.count
    @critical_alerts = current_caretaker.critical_alerts_count

    # Recent vital signs data for charts
    @vital_signs_chart_data = prepare_vital_signs_chart_data

    # Location data for live map
    @location_data = @patients.map do |patient|
      {
        id: patient.id,
        name: patient.name,
        latitude: patient.latitude,
        longitude: patient.longitude,
        status: patient.location_status,
        last_seen: patient.last_seen_at,
        primary: current_caretaker.primary_patients.include?(patient)
      }
    end

    # Recent activities
    @recent_activities = Activity.joins(:patient)
                                .where(patient: @patients)
                                .recent
                                .limit(15)
                                .includes(:patient)

    # Recent device logs
    @recent_device_logs = current_caretaker.recent_device_logs.limit(20)

    # Patients needing attention
    @attention_patients = current_caretaker.patients_needing_attention

    # Device status summary
    @device_summary = prepare_device_status_summary
  end

  def patient_vitals_chart
    patient = current_caretaker.patients.find(params[:patient_id])

    # Get vital signs for the last 24 hours
    vital_signs = patient.vital_signs
                         .where("recorded_at > ?", 24.hours.ago)
                         .order(:recorded_at)

    chart_data = {
      heart_rate: vital_signs.pluck(:recorded_at, :heart_rate),
      blood_pressure_systolic: vital_signs.pluck(:recorded_at, :blood_pressure_systolic),
      blood_pressure_diastolic: vital_signs.pluck(:recorded_at, :blood_pressure_diastolic),
      temperature: vital_signs.pluck(:recorded_at, :temperature).map { |record| [ record[0], record[1]&.round(2) ] }
    }

    render json: chart_data
  end

  def live_patient_data
    patient = current_caretaker.patients.find(params[:patient_id])

    data = {
      location: {
        latitude: patient.latitude,
        longitude: patient.longitude,
        status: patient.location_status,
        last_seen: patient.last_seen_at
      },
      vitals: patient.latest_vital_signs&.as_json(
        only: [ :heart_rate, :blood_pressure_systolic, :blood_pressure_diastolic, :temperature, :recorded_at ],
        methods: [ :status, :status_color ]
      ),
      recent_activities: patient.activities.recent.limit(5).as_json(
        only: [ :activity_type, :description, :recorded_at ],
        methods: [ :formatted_type, :time_ago ]
      ),
      device_status: patient.device_logs.recent.group(:device_type).maximum(:recorded_at)
    }

    render json: data
  end

  private

  def prepare_vital_signs_chart_data
    # Get vital signs for all patients in the last 24 hours for trending
    chart_data = {}

    @patients.each do |patient|
      recent_vitals = patient.vital_signs
                             .where("recorded_at > ?", 24.hours.ago)
                             .order(:recorded_at)
                             .limit(50)

      if recent_vitals.any?
        # Prepare data for Chart.js format
        timestamps = recent_vitals.pluck(:recorded_at).map { |time| time.strftime("%H:%M") }

        chart_data[patient.name] = {
          patient_id: patient.id,
          labels: timestamps,
          datasets: {
            heart_rate: recent_vitals.pluck(:heart_rate),
            temperature: recent_vitals.pluck(:temperature).map { |temp| temp&.round(2) },
            blood_pressure_systolic: recent_vitals.pluck(:blood_pressure_systolic),
            blood_pressure_diastolic: recent_vitals.pluck(:blood_pressure_diastolic)
          },
          latest_status: recent_vitals.last&.status || "unknown",
          latest_readings: {
            heart_rate: recent_vitals.last&.heart_rate,
            temperature: recent_vitals.last&.temperature&.round(2),
            blood_pressure: "#{recent_vitals.last&.blood_pressure_systolic}/#{recent_vitals.last&.blood_pressure_diastolic}"
          }
        }
      end
    end

    chart_data
  end

  def prepare_device_status_summary
    device_logs = DeviceLog.joins(:patient)
                           .where(patient: @patients)
                           .where("recorded_at > ?", 1.hour.ago)

    {
      total_devices: device_logs.distinct.count(:device_id),
      active_devices: device_logs.where("recorded_at > ?", 10.minutes.ago).distinct.count(:device_id),
      low_battery_devices: device_logs.low_battery.distinct.count(:device_id),
      poor_signal_devices: device_logs.poor_signal.distinct.count(:device_id),
      device_types: device_logs.group(:device_type).distinct.count(:device_id)
    }
  end
end
