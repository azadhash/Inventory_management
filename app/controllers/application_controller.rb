class ApplicationController < ActionController::Base
  include ApplicationHelper

  def has_current_user
    if !current_user
      redirect_to dashboard_path
    end
  end
  def logged_in
    if current_user
      redirect_to dashboard_path
    end
  end
  def user_type
    if !authenticate_user
      redirect_to dashboard_path
    end
  end
end
