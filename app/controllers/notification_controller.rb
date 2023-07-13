# frozen_string_literal: true

# this is the Notification controller
class NotificationController < ApplicationController
  before_action :current_user?
  def mark_read
    Notification.where(read: false, recipient_id: current_user.id).update(read: true)
  end
end
