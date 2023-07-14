# frozen_string_literal: true

# this is the Notification controller
class NotificationController < ApplicationController
  before_action :current_user?
  def mark_read
    Notification.update_unread(current_user.id)
  end
end
