class Activity < ApplicationRecord
  belongs_to :patient

  # Validations
  validates :activity_type, presence: true, inclusion: {
    in: %w[walking sitting lying_down standing eating medication_taken bathroom social_interaction sleeping]
  }
  validates :recorded_at, presence: true

  # Scopes
  scope :recent, -> { order(recorded_at: :desc) }
  scope :today, -> { where("recorded_at > ?", 1.day.ago) }
  scope :by_type, ->(type) { where(activity_type: type) }

  # Methods
  def activity_icon
    case activity_type
    when "walking" then "bi-person-walking"
    when "sitting" then "bi-person-standing"
    when "lying_down" then "bi-moon-fill"
    when "standing" then "bi-person-standing"
    when "eating" then "bi-egg-fried"
    when "medication_taken" then "bi-capsule"
    when "bathroom" then "bi-house-door-fill"
    when "social_interaction" then "bi-people-fill"
    when "sleeping" then "bi-moon-stars-fill"
    else "bi-activity"
    end
  end

  def formatted_type
    activity_type.humanize.titleize
  end

  def time_ago
    return "Just now" if recorded_at > 1.minute.ago
    return "#{((Time.current - recorded_at) / 1.minute).round}m ago" if recorded_at > 1.hour.ago
    return "#{((Time.current - recorded_at) / 1.hour).round}h ago" if recorded_at > 1.day.ago
    recorded_at.strftime("%m/%d %I:%M %p")
  end

  def location
    return nil unless latitude && longitude
    [ latitude, longitude ]
  end
end
