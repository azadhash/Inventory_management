# frozen_string_literal: true

# this is the Issues controller
class IssuesController < ApplicationController
  before_action :current_user?
  before_action :user_type, except: %i[index create new]
  def index
    intialize_session
    session[:query] = nil
    @issues = if authenticate_user
                Issue.all
              else
                current_user.issues
              end
    sort_param = params[:sort_by]
    @issues = sort_obj(sort_param, @issues)
  end

  def new
    if !authenticate_user
      @issue = Issue.new
    else
      redirect_to issues_path
    end
  end

  def create
    @issue = Issue.new(issue_params)
    @issue.user_id = current_user.id
    if @issue.save
      redirect_to issues_path, flash: { notice: 'Issue was successfully raised.' }
    else
      render :new
    end
  end

  def edit
    @issue = Issue.find(params[:id])
  end

  def update
    @issue = Issue.find(params[:id])

    if @issue.update(issue_params)
      send_mail_and_notification if @issue.status
      redirect_to issues_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def send_mail_and_notification
    UserMailer.issue_status_email(@issue).deliver_later
    user = @issue.user
    notification = Notification.create(recipient: user, priority: 'normal',
                                       message: "your issue with id #{@issue.id} is resolved")
    ActionCable.server.broadcast("NotificationsChannel_#{user.id}", { notification: })
  end

  def search
    @issues = search_obj(params, Issue)
  end

  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy

    redirect_to issues_path, status: :see_other
  end

  def issue_params
    params.require(:issue).permit(:item_id, :description, :status)
  end
end
