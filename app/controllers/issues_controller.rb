# frozen_string_literal: true

# this is the Issues controller
class IssuesController < ApplicationController
  include IssuesHelper
  before_action :current_user?
  before_action :admin?, except: %i[index create new search show]
  before_action :fetch_issue, only: %i[show update]
  def index
    initialize_session
    session[:query] = nil
    @issues = Issue.includes(:item).all
    fetch_issues_of_employee
    sort_param = params[:sort_by]
    @issues = sort_obj(sort_param, @issues)
    @issues = @issues.page(params[:page]).per(5)
  end

  def new
    @issue = Issue.new
  end

  def create
    @issue = Issue.new(issue_params)
    @issue.user_id = current_user.id
    @issue.id = generate_complaint_id
    if @issue.save
      redirect_to issues_path, flash: { notice: 'Issue was raised successfully.' }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def update
    if @issue.update(issue_params)
      send_mail_and_notification if @issue.status
      redirect_to @issue, flash: { notice: 'Issue resolved' }
    else
      redirect_to @issue, flash: { notice: 'Issue not resolved' }
    end
  end

  def search
    @issues = search_obj(params, Issue)
    fetch_issues_of_employee
    @issues = @issues.page(params[:page]).per(5)
  end

  private

  def fetch_issue
    @issue = Issue.find(params[:id])
  end

  def generate_complaint_id
    loop do
      random_id = SecureRandom.random_number(10_000)
      return random_id if Issue.find_by(id: random_id).nil?
    end
  end

  def issue_params
    params.require(:issue).permit(:item_id, :description, :status)
  end
end
