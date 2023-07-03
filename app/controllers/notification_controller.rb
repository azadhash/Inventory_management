class NotificationController < ApplicationController
  before_action :has_current_user
  
  def count
    @count = current_user.notifications.where(read: false).count
    render json: { count: @count }
  end

  def mark_read
    Notification.where(read: false, recipient_id: current_user.id).update(read: true)
  end
end
