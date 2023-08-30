# frozen_string_literal: true
# rubocop:disable all
# this is the Application helper
module ApplicationHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticate_user
    current_user&.admin
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

  def show_errors(object, field_name)
    return unless object.errors.any?
    return if object.errors.messages[field_name].blank?

    object.errors.messages[field_name].join(', ')
  end

  def delete_link(path)
    link_to ('<i class="fa fa-trash" style="color: #e00b0b" title="Delete Details"></i>').html_safe,
              path,
              method: :delete,
              data: { confirm: "Are you sure?" },
              class: 'btn'
  end

  def edit_link(path)
    link_to ('<i class="fa-solid fa-pen-to-square" style="color: #ff9500;" title="Edit Details"></i>').html_safe,
              path,
              method: :get,
              class: 'btn'
  end
  
  def show_link(path)
    link_to ('<i class="fa-solid fa-eye" style="color: #0b7fe0;" title="Show Details"></i>').html_safe,
              path,
              method: :get,
              class: 'btn'
  end

  def render_notifications(user_id)
    notifications = Notification.unread(user_id)
    notifications.map do |notification|
      priority_class = 'text-'+ notification.priority
      content_tag(:li, notification.message, class: "notification-item #{priority_class}")
    end.join.html_safe
  end

end
