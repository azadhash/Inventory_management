# frozen_string_literal: true
# rubocop:disable all
# this is the search filter helper
module SearchFilterHelper
  def initialize_session_param(key)
    session[key] = params[key].presence || nil
  end

  def initialize_session
    session[:back] = 'item'
    initialize_session_param(:category_id)
    initialize_session_param(:brand_id)
    initialize_session_param(:status)
    initialize_session_param(:active)
    initialize_session_param(:role)
    initialize_session_param(:priority)
  end

  def search_obj(params, model)
    query = extract_query(params)
    results = perform_search(query, model)
    results = apply_filters(results, params)
    sort_results(results, params[:sort_by])
  end

  def extract_query(params)
    query = params[:search_category].presence && params[:search_category][:query] || params[:query]
    session[:query] = query unless query.nil?
    query || session[:query]
  end

  def perform_search(query, model)
    query.present? ? model.search_result(query.strip).records : model.all
  end

  def apply_filters(results, params)
    initialize_session if params[:filter]
    filter(results)
  end

  def filter(obj)
    obj = obj.where(category_id: session[:category_id]) if session[:category_id].present?
    obj = obj.where(brand_id: session[:brand_id]) if session[:brand_id].present?
    obj = obj.where(status: session[:status]) if session[:status].present?
    obj = obj.where(active: session[:active]) if session[:active].present?
    obj = obj.where(admin: session[:role]) if session[:role].present?
    obj = obj.where(priority: session[:priority]) if session[:priority].present?

    obj
  end

  def sort_results(results, sort_param)
    sort_obj(sort_param, results)
  end

  def check_session
    session[:category_id].present? || session[:brand_id].present? || session[:status].present? ||
      session[:active].present? || session[:role].present? || session[:priority].present?
  end
end
