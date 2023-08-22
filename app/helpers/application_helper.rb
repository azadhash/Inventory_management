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

  def sort_obj(sort_param, obj)
    case sort_param
    when 'id_asc'
      obj.order(id: :asc)
    when 'id_desc'
      obj.order(id: :desc)
    when 'name_asc'
      obj.order(name: :asc)
    when 'name_desc'
      obj.order(name: :desc)
    when 'user_name_asc'
      obj.joins(:user).order('users.name ASC')
    when 'user_name_desc'
      obj.joins(:user).order('users.name DESC')
    when 'user_id_asc'
      obj.order(user_id: :asc)
    when 'user_id_desc'
      obj.order(user_id: :desc)
    when 'brand_asc'
      obj.joins(:brand).order('brands.name ASC')
    when 'brand_desc'
      obj.joins(:brand).order('brands.name DESC')
    when 'category_asc'
      obj.joins(:category).order('categories.name ASC')
    when 'category_desc'
      obj.joins(:category).order('categories.name DESC')
    when 'item_id_asc'
      obj.order(item_id: :asc)
    when 'item_id_desc'
      obj.order(item_id: :desc)
    else
      obj.order(id: :asc)
    end
  end

  def filter(obj)
    obj = obj.where(category_id: session[:category_id]) if session[:category_id].present?
    obj = obj.where(brand_id: session[:brand_id]) if session[:brand_id].present?
    obj = obj.where(status: session[:status]) if session[:status].present?
    obj = obj.where(active: session[:active]) if session[:active].present?

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

  def check_session
    session[:category_id].present? || session[:brand_id].present? || session[:status].present? || session[:active].present?
  end
end
