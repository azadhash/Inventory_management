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

  def intialize_session
    session[:category_id] = params[:category_id].presence || nil
    session[:brand_id] = params[:brand_id].presence || nil
    session[:status] = params[:status].presence || nil
  end

  def search_obj(params, model)
    query = extract_query(params)
    results = perform_search(query, model)
    results = apply_filters(results, params)
    sort_results(results, params[:sort_by])
  end

  def extract_query(params)
    query = params.dig(:search_categories, :query)
    session[:query] = query if query.present?
    query || session[:query]
  end

  def perform_search(query, model)
    query.present? ? model.search_result(query).records : model.all
  end

  def apply_filters(results, params)
    intialize_session if params[:filter]
    filter(results)
  end

  def sort_results(results, sort_param)
    sort_obj(sort_param, results)
  end
end
