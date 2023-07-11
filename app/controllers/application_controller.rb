class ApplicationController < ActionController::Base
  include ApplicationHelper

  def has_current_user
    if !current_user
      redirect_to login_path, flash: { alert: "You must be logged in to access this page" }
    end
  end
  def logged_in
    if current_user
      redirect_to dashboard_path, flash: { alert: "You are already logged in" }
    end
  end
  def user_type
    if !authenticate_user
      redirect_to dashboard_path, flash: { alert: "You are not an admin" }
    end
  end
  def intialize_session
    session[:category_id] = params[:category_id].presence || nil
    session[:brand_id] = params[:brand_id].presence || nil
    session[:status] = params[:status].presence || nil
  end
  def search_obj(params,model)
    query = params[:search_categories].presence && params[:search_categories][:query]
    if query
      session[:query] = query
      results = model.search_result(query).records 
    elsif session[:query]
      results = model.search_result(session[:query]).records
    else
      results = model.all
    end
    if params[:filter]
      intialize_session
    end 
    results = filter(results)
    sort_param = params[:sort_by]
    results = sort_obj(sort_param,results)
  end 
end
