# frozen_string_literal: true

# Description: This channel is used to send notifications to the user
class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    if current_user.admin
      stream_from 'AdminChannel'
    else
      stream_from "NotificationsChannel_#{current_user.id}"
    end
  end

  def unsubscribed; end
end
