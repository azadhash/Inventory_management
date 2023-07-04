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
  def intialize_session
    session[:category_id] = params[:category_id].presence || nil
    session[:brand_id] = params[:brand_id].presence || nil
    session[:status] = params[:status].presence || nil
  end
end
