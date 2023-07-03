class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    if current_user.admin
      stream_from "AdminChannel"
    else
      stream_from "NotificationsChannel_#{current_user.id}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
