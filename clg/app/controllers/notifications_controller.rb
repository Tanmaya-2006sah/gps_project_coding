class NotificationsController < ApplicationController
  before_action :set_notification, only: [ :show, :mark_as_read ]

  def index
    notifications_query = current_user.notifications
                                     .includes(:patient)
                                     .recent

    @unread_count = current_user.unread_notifications_count
    @filter_type = params[:type]
    @filter_priority = params[:priority]

    notifications_query = notifications_query.by_type(@filter_type) if @filter_type.present?
    notifications_query = notifications_query.by_priority(@filter_priority) if @filter_priority.present?

    # Simple pagination without Kaminari
    @per_page = 20
    @current_page = (params[:page] || 1).to_i
    @total_count = notifications_query.count
    @total_pages = (@total_count.to_f / @per_page).ceil

    @notifications = notifications_query.limit(@per_page)
                                       .offset((@current_page - 1) * @per_page)
  end

  def show
    @notification.mark_as_read! unless @notification.read?
  end

  def mark_as_read
    @notification.mark_as_read!

    respond_to do |format|
      format.html { redirect_to notifications_path, notice: "Notification marked as read." }
      format.json { render json: { status: "success" } }
    end
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end
end
