# frozen_string_literal: true

# this is the Issues controller
class IssuesController < ApplicationController
  include IssuesHelper
  before_action :current_user?
  before_action :user_type, except: %i[index create new]
  before_action :fetch_issue, only: %i[edit update destroy]
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
    @issues = @issues.page(params[:page]).per(7)
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

  def edit; end

  def update
    if @issue.update(issue_params)
      send_mail_and_notification if @issue.status
      redirect_to issues_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def search
    @issues = search_obj(params, Issue)
    @issues = @issues.page(params[:page]).per(7)
  end

  def destroy
    @issue.destroy

    redirect_to issues_path, status: :see_other
  end

  private

  def fetch_issue
    @issue = Issue.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(:item_id, :description, :status)
  end
end
