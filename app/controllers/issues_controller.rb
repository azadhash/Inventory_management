class IssuesController < ApplicationController
  before_action :has_current_user
  before_action :user_type, except: [:index,:create,:new]
  def index
    if authenticate_user
      @issues = Issue.all
    else
      @issues = current_user.issues
    end
  end

  def new
    if !authenticate_user
      @issue = Issue.new
    else
      redirect_to issues_path
    end
  end
  
  # def show
  #   @issue = Issue.find(params[:id])
  # end

  def create
    @issue = Issue.new(issue_params)
    @issue.user_id = current_user.id
    if @issue.save
      redirect_to issues_path
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
      if @issue.status 
        UserMailer.issue_status_email(@issue).deliver_now
      end
      redirect_to issues_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy

    redirect_to issues_path, status: :see_other
  end

  def issue_params
    params.require(:issue).permit(:item_id,:description,:status)
  end 
end
