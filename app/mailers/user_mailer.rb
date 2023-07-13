# frozen_string_literal: true

# this is the UserMailer
class UserMailer < ApplicationMailer
  default from: 'workazadsingh@gmail.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end

  def issue_status_email(issue)
    @issue = issue
    @user = @issue.user
    mail(to: @user.email, subject: 'Issue Status')
  end
end
