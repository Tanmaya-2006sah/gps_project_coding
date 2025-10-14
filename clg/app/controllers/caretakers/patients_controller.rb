class Caretakers::PatientsController < Caretakers::ApplicationController
  before_action :set_patient, only: [ :show, :update_assignment, :remove_assignment ]
  layout "caretaker_dashboard"

  def index
    @patients = current_caretaker.patients
                               .includes(:vital_signs, :activities, :device_logs, :primary_caretaker)
                               .order(:name)

    @primary_patients = @patients.select { |p| p.primary_caretaker == current_caretaker }
    @secondary_patients = @patients.reject { |p| p.primary_caretaker == current_caretaker }
  end

  def show
    @assignment = current_caretaker.patient_caretakers.find_by(patient: @patient)
    @vital_signs = @patient.vital_signs.recent.order(recorded_at: :desc).limit(50)
    @activities = @patient.activities.recent.order(recorded_at: :desc).limit(30)
    @device_logs = @patient.device_logs.recent.order(recorded_at: :desc).limit(100)
    @geofence_zones = @patient.geofence_zones.active

    # Vital signs statistics
    @vitals_stats = calculate_vitals_statistics(@vital_signs)

    # Device status
    @device_status = @device_logs.group(:device_type).group(:device_id).maximum(:recorded_at)
  end

  def vitals_chart_data
    @patient = current_caretaker.patients.find(params[:id])
    period = params[:period]&.to_i || 24 # hours

    vital_signs = @patient.vital_signs
                          .where("recorded_at > ?", period.hours.ago)
                          .order(:recorded_at)

    render json: {
      labels: vital_signs.pluck(:recorded_at).map { |time| time.strftime("%H:%M") },
      datasets: [
        {
          label: "Heart Rate (BPM)",
          data: vital_signs.pluck(:heart_rate),
          borderColor: "rgb(220, 53, 69)",
          backgroundColor: "rgba(220, 53, 69, 0.1)",
          yAxisID: "y"
        },
        {
          label: "Systolic BP",
          data: vital_signs.pluck(:blood_pressure_systolic),
          borderColor: "rgb(0, 123, 255)",
          backgroundColor: "rgba(0, 123, 255, 0.1)",
          yAxisID: "y1"
        },
        {
          label: "Diastolic BP",
          data: vital_signs.pluck(:blood_pressure_diastolic),
          borderColor: "rgb(0, 123, 255, 0.7)",
          backgroundColor: "rgba(0, 123, 255, 0.05)",
          yAxisID: "y1"
        },
        {
          label: "Temperature (°F)",
          data: vital_signs.pluck(:temperature).map { |temp| temp&.round(2) },
          borderColor: "rgb(255, 193, 7)",
          backgroundColor: "rgba(255, 193, 7, 0.1)",
          yAxisID: "y2"
        }
      ],
      options: {
        responsive: true,
        interaction: {
          mode: "index",
          intersect: false
        },
        scales: {
          x: {
            display: true,
            title: {
              display: true,
              text: "Time"
            }
          },
          y: {
            type: "linear",
            display: true,
            position: "left",
            title: {
              display: true,
              text: "Heart Rate (BPM)"
            }
          },
          y1: {
            type: "linear",
            display: true,
            position: "right",
            title: {
              display: true,
              text: "Blood Pressure (mmHg)"
            },
            grid: {
              drawOnChartArea: false
            }
          },
          y2: {
            type: "linear",
            display: false,
            position: "right",
            title: {
              display: true,
              text: "Temperature (°F)"
            }
          }
        }
      }
    }
  end

  def update_assignment
    @assignment = current_caretaker.patient_caretakers.find_by(patient: @patient)

    if @assignment&.update(assignment_params)
      redirect_to caretakers_patient_path(@patient), notice: "Assignment updated successfully."
    else
      redirect_to caretakers_patient_path(@patient), alert: "Failed to update assignment."
    end
  end

  def remove_assignment
    @assignment = current_caretaker.patient_caretakers.find_by(patient: @patient)

    if @assignment&.destroy
      redirect_to caretakers_patients_path, notice: "Patient assignment removed successfully."
    else
      redirect_to caretakers_patient_path(@patient), alert: "Failed to remove assignment."
    end
  end

  private

  def set_patient
    @patient = current_caretaker.patients.find(params[:id])
  end

  def assignment_params
    params.require(:patient_caretaker).permit(:primary_caretaker, :notes)
  end

  def calculate_vitals_statistics(vital_signs)
    return {} if vital_signs.empty?

    heart_rates = vital_signs.pluck(:heart_rate)
    systolic_bps = vital_signs.pluck(:blood_pressure_systolic)
    diastolic_bps = vital_signs.pluck(:blood_pressure_diastolic)
    temperatures = vital_signs.pluck(:temperature)

    {
      heart_rate: {
        avg: (heart_rates.sum.to_f / heart_rates.count).round(1),
        min: heart_rates.min,
        max: heart_rates.max
      },
      blood_pressure: {
        systolic: {
          avg: (systolic_bps.sum.to_f / systolic_bps.count).round(1),
          min: systolic_bps.min,
          max: systolic_bps.max
        },
        diastolic: {
          avg: (diastolic_bps.sum.to_f / diastolic_bps.count).round(1),
          min: diastolic_bps.min,
          max: diastolic_bps.max
        }
      },
      temperature: {
        avg: (temperatures.sum.to_f / temperatures.count).round(2),
        min: temperatures.min&.round(2),
        max: temperatures.max&.round(2)
      }
    }
  end
end
