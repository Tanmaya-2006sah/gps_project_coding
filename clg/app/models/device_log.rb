class DeviceLog < ApplicationRecord
  belongs_to :patient

  # Validations
  validates :device_type, presence: true, inclusion: { in: %w[gps_tracker heart_monitor smart_watch emergency_button medication_dispenser] }
  validates :device_id, presence: true
  validates :event_type, presence: true, inclusion: { in: %w[location_update vital_signs_reading button_press low_battery device_offline medication_taken fall_detected] }
  validates :recorded_at, presence: true
  validates :battery_level, numericality: { in: 0..100 }, allow_blank: true
  validates :signal_strength, numericality: { in: 0..100 }, allow_blank: true

  # Scopes
  scope :recent, -> { where("recorded_at > ?", 24.hours.ago) }
  scope :today, -> { where("recorded_at > ?", 1.day.ago) }
  scope :by_device_type, ->(type) { where(device_type: type) if type.present? }
  scope :by_event_type, ->(type) { where(event_type: type) if type.present? }
  scope :low_battery, -> { where("battery_level <= ?", 20) }
  scope :poor_signal, -> { where("signal_strength <= ?", 30) }

  # Methods
  def device_name
    device_type.humanize
  end

  def event_description
    case event_type
    when "location_update" then "Location updated"
    when "vital_signs_reading" then "Vital signs recorded"
    when "button_press" then "Emergency button pressed"
    when "low_battery" then "Low battery warning"
    when "device_offline" then "Device went offline"
    when "medication_taken" then "Medication taken"
    when "fall_detected" then "Fall detected"
    else event_type.humanize
    end
  end

  def battery_status
    return "Unknown" unless battery_level
    case battery_level
    when 0..10 then "Critical"
    when 11..20 then "Low"
    when 21..50 then "Medium"
    when 51..100 then "Good"
    end
  end

  def signal_status
    return "Unknown" unless signal_strength
    case signal_strength
    when 0..30 then "Poor"
    when 31..60 then "Fair"
    when 61..80 then "Good"
    when 81..100 then "Excellent"
    end
  end

  def battery_color
    case battery_status
    when "Critical" then "danger"
    when "Low" then "warning"
    when "Medium" then "info"
    when "Good" then "success"
    else "secondary"
    end
  end

  def signal_color
    case signal_status
    when "Poor" then "danger"
    when "Fair" then "warning"
    when "Good" then "info"
    when "Excellent" then "success"
    else "secondary"
    end
  end

  def time_ago
    ActionController::Base.helpers.time_ago_in_words(recorded_at)
  end

  def formatted_event_data
    return {} unless event_data.present?
    JSON.parse(event_data)
  rescue JSON::ParserError
    {}
  end
end
