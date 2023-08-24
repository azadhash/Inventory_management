# frozen_string_literal: true

# this is the Notification controller
class NotificationController < ApplicationController
  before_action :current_user?
  def mark_read
    current_user.notifications.delete_all
  end

  def mark
    notification = Notification.find(params[:id])
    notification.update(read: true)
  end
end
