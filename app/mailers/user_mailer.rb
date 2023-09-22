# frozen_string_literal: true

# this is the UserMailer
class UserMailer < ApplicationMailer
  default from: email_address_with_name('workazadsingh@gmail.com', 'Azad Singh')

  def welcome_email(user)
    @user = user
    mail(to: email_address_with_name(@user.email, @user.name), subject: 'Login Link')
  end

  def issue_status_email(issue)
    @issue = issue
    @user = @issue.user
    mail(to: email_address_with_name(@user.email, @user.name), subject: 'Issue resloved')
  end
end
