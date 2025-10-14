module NotificationsHelper
  def notification_priority_color(priority)
    case priority
    when "low" then "secondary"
    when "medium" then "primary"
    when "high" then "warning"
    when "critical" then "danger"
    else "secondary"
    end
  end

  def notification_icon(notification_type)
    case notification_type
    when "geofence_violation" then "bi-geo-alt-fill"
    when "vital_signs_alert" then "bi-heart-pulse"
    when "activity_alert" then "bi-person-walking"
    when "system_alert" then "bi-gear"
    else "bi-bell"
    end
  end
end
