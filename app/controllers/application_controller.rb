# frozen_string_literal: true

# This is the application controller
class ApplicationController < ActionController::Base
  include ApplicationHelper
  def current_user?
    return if current_user

    redirect_to login_path, flash: { alert: 'You must be logged in to access this page' }
  end

  def logged_in
    return unless current_user

    redirect_to dashboard_path, flash: { alert: 'You are already logged in' }
  end

  def user_type
    return if authenticate_user

    redirect_to dashboard_path, flash: { alert: 'You are not an admin' }
  end

  def initialize_session_param(key)
    session[key] = params[key].presence || nil
  end

  def initialize_session
    initialize_session_param(:category_id)
    initialize_session_param(:brand_id)
    initialize_session_param(:status)
    initialize_session_param(:active)
  end

  def search_obj(params, model)
    query = extract_query(params)
    results = perform_search(query, model)
    results = apply_filters(results, params)
    sort_results(results, params[:sort_by])
  end

  def extract_query(params)
    query = params[:search_category].presence && params[:search_category][:query]
    session[:query] = query unless query.nil?
    query || session[:query]
  end

  def perform_search(query, model)
    query.present? ? model.search_result(query).records : model.all
  end

  def apply_filters(results, params)
    initialize_session if params[:filter]
    filter(results)
  end

  def sort_results(results, sort_param)
    sort_obj(sort_param, results)
  end
end
