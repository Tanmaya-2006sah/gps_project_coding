class Patient < ApplicationRecord
  belongs_to :user
  has_many :vital_signs, dependent: :destroy
  has_many :geofence_zones, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :device_logs, dependent: :destroy
  has_many :patient_caretakers, dependent: :destroy
  has_many :caretakers, through: :patient_caretakers
  has_one :primary_caretaker_assignment, -> { where(primary_caretaker: true) }, class_name: "PatientCaretaker"
  has_one :primary_caretaker, through: :primary_caretaker_assignment, source: :caretaker

  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :age, presence: true, numericality: { greater_than: 0, less_than: 150 }
  validates :gender, presence: true, inclusion: { in: %w[male female other] }
  validates :latitude, :longitude, presence: true, numericality: true

  # Scopes
  scope :recent_activity, -> { where("last_seen_at > ?", 1.hour.ago) }
  scope :inactive, -> { where("last_seen_at < ? OR last_seen_at IS NULL", 1.hour.ago) }

  # Methods
  def current_location
    return nil unless latitude && longitude
    [ latitude, longitude ]
  end

  def latest_vital_signs
    vital_signs.order(recorded_at: :desc).first
  end

  def recent_activities
    activities.order(recorded_at: :desc).limit(10)
  end

  def is_in_geofence?
    return true if geofence_zones.empty?
    return false unless latitude && longitude

    geofence_zones.active.any? do |zone|
      next false unless zone.center_latitude && zone.center_longitude && zone.radius_meters

      # Use a simple distance calculation to avoid Geocoder issues
      begin
        patient_lat = latitude.to_f
        patient_lng = longitude.to_f
        zone_lat = zone.center_latitude.to_f
        zone_lng = zone.center_longitude.to_f
        zone_radius = zone.radius_meters.to_f

        # Validate all values are numeric and not nil/zero
        next false if [ patient_lat, patient_lng, zone_lat, zone_lng, zone_radius ].any? { |val| val.nil? || val == 0.0 }

        # Simple Haversine distance calculation in meters
        rad_per_deg = Math::PI / 180  # PI / 180
        rkm = 6371000                # Earth radius in meters
        rm = rkm

        dlat_rad = (zone_lat - patient_lat) * rad_per_deg
        dlon_rad = (zone_lng - patient_lng) * rad_per_deg

        lat1_rad = patient_lat * rad_per_deg
        lat2_rad = zone_lat * rad_per_deg

        a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))

        distance = rm * c

        distance <= zone_radius
      rescue => e
        Rails.logger.error "Geofence calculation error: #{e.message} for patient #{id}, zone #{zone.id}"
        Rails.logger.error "  Patient coords: #{latitude.inspect}, #{longitude.inspect}"
        Rails.logger.error "  Zone coords: #{zone.center_latitude.inspect}, #{zone.center_longitude.inspect}"
        false
      end
    end
  end

  def location_status
    case
    when last_seen_at.nil? || last_seen_at < 6.hours.ago
      "offline"
    when last_seen_at < 1.hour.ago
      "away"
    when is_in_geofence?
      "safe"
    else
      "outside_zone"
    end
  end

  def status_color
    case location_status
    when "safe" then "success"
    when "away" then "warning"
    when "outside_zone" then "danger"
    when "offline" then "secondary"
    end
  end
end
