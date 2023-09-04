# frozen_string_literal: true

# This is the application controller
class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SearchFilterHelper
  include SortHelper
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_method

  def not_found_method
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  def current_user?
    return if current_user

    redirect_to login_path, flash: { alert: 'You are not logged in please login to access this page.' }
  end

  def logged_in
    return unless current_user

    redirect_to dashboard_path, flash: { alert: 'You are already logged in' }
  end

  def admin?
    return if authenticate_user

    redirect_to dashboard_path, flash: { alert: "You don't have access to this page" }
  end
end
