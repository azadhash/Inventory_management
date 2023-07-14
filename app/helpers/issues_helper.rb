# frozen_string_literal: true

# this is the Issues helper
module IssuesHelper
  def send_mail_and_notification
    UserMailer.issue_status_email(@issue).deliver_later
    user = @issue.user
    notification = Notification.create(recipient: user, priority: 'normal',
                                       message: "your issue with id #{@issue.id} is resolved")
    ActionCable.server.broadcast("NotificationsChannel_#{user.id}", { notification: })
  end
end
