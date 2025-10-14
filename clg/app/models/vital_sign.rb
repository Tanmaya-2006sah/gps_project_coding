class VitalSign < ApplicationRecord
  belongs_to :patient

  # Validations
  validates :heart_rate, presence: true, numericality: { greater_than: 0, less_than: 300 }
  validates :blood_pressure_systolic, presence: true, numericality: { greater_than: 0, less_than: 300 }
  validates :blood_pressure_diastolic, presence: true, numericality: { greater_than: 0, less_than: 200 }
  validates :temperature, presence: true, numericality: { greater_than: 85.0, less_than: 115.0 }
  validates :recorded_at, presence: true

  # Scopes
  scope :recent, -> { where("recorded_at > ?", 24.hours.ago) }
  scope :today, -> { where("recorded_at > ?", 1.day.ago) }

  # Methods
  def heart_rate_status
    case heart_rate
    when 0..50 then "low"
    when 51..100 then "normal"
    when 101..150 then "elevated"
    else "high"
    end
  end

  def blood_pressure_status
    if blood_pressure_systolic < 90 || blood_pressure_diastolic < 60
      "low"
    elsif blood_pressure_systolic > 140 || blood_pressure_diastolic > 90
      "high"
    else
      "normal"
    end
  end

  def temperature_status
    case temperature
    when 0..96.8 then "low"
    when 96.9..99.5 then "normal"
    when 99.6..100.4 then "elevated"
    else "high"
    end
  end

  def overall_status
    statuses = [ heart_rate_status, blood_pressure_status, temperature_status ]
    return "critical" if statuses.include?("high")
    return "warning" if statuses.include?("elevated") || statuses.include?("low")
    "normal"
  end

  # Alias for API compatibility
  def status
    overall_status
  end

  def status_color
    case overall_status
    when "normal" then "success"
    when "warning" then "warning"
    when "critical" then "danger"
    end
  end
end
