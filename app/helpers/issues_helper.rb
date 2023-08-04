# frozen_string_literal: true

# this is the Issues helper
module IssuesHelper
  def send_mail_and_notification
    UserMailer.issue_status_email(@issue).deliver_later
    user = @issue.user
    notification = Notification.create(recipient: user, priority: 'low',
                                       message: "Your Issue with the Item #{@issue.item.name}
                                                having issue id #{@issue.id} is resolved")
    ActionCable.server.broadcast("NotificationsChannel_#{user.id}", { notification: })
  end

  def fetch_issues_of_employee
    return if authenticate_user

    @issues = @issues.where(user_id: current_user.id)
  end
end
