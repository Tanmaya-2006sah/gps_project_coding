class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :patient, optional: true

  # Validations
  validates :title, presence: true, length: { maximum: 200 }
  validates :message, presence: true, length: { maximum: 1000 }
  validates :notification_type, presence: true, inclusion: {
    in: %w[geofence_violation vital_signs_alert activity_alert system_alert]
  }
  validates :priority, presence: true, inclusion: { in: %w[low medium high critical] }

  # Scopes
  scope :unread, -> { where(read: false) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_priority, ->(priority) { where(priority: priority) }
  scope :by_type, ->(type) { where(notification_type: type) }

  # Methods
  def mark_as_read!
    update!(read: true)
  end

  def priority_badge_class
    case priority
    when "low" then "badge-secondary"
    when "medium" then "badge-primary"
    when "high" then "badge-warning"
    when "critical" then "badge-danger"
    end
  end

  def type_icon
    case notification_type
    when "geofence_violation" then "bi-geo-alt-fill"
    when "vital_signs_alert" then "bi-heart-pulse-fill"
    when "activity_alert" then "bi-activity"
    when "system_alert" then "bi-exclamation-triangle-fill"
    end
  end

  def time_ago
    return "Just now" if created_at > 1.minute.ago
    return "#{((Time.current - created_at) / 1.minute).round}m ago" if created_at > 1.hour.ago
    return "#{((Time.current - created_at) / 1.hour).round}h ago" if created_at > 1.day.ago
    created_at.strftime("%m/%d %I:%M %p")
  end
end
