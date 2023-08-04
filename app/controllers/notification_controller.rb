# frozen_string_literal: true

# this is the Notification controller
class NotificationController < ApplicationController
  before_action :current_user?
  def mark_read
    current_user.notifications.delete_all
  end
end
