class GeofenceZone < ApplicationRecord
  belongs_to :patient

  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :center_latitude, :center_longitude, presence: true, numericality: true
  validates :radius_meters, presence: true, numericality: { greater_than: 0, less_than: 50000 }

  # Scopes
  scope :active, -> { where(active: true) }

  # Methods
  def center_coordinates
    [ center_latitude, center_longitude ]
  end

  def contains_point?(latitude, longitude)
    # Use custom Haversine calculation for consistency
    patient_lat = latitude.to_f
    patient_lng = longitude.to_f
    zone_lat = center_latitude.to_f
    zone_lng = center_longitude.to_f

    # Simple Haversine distance calculation in meters
    rad_per_deg = Math::PI / 180
    rm = 6371000 # Earth radius in meters

    dlat_rad = (zone_lat - patient_lat) * rad_per_deg
    dlon_rad = (zone_lng - patient_lng) * rad_per_deg

    lat1_rad = patient_lat * rad_per_deg
    lat2_rad = zone_lat * rad_per_deg

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))

    distance = rm * c
    distance <= radius_meters
  end

  def radius_km
    radius_meters / 1000.0
  end
end
