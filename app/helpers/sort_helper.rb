# frozen_string_literal: true
# rubocop:disable all
# this is the Application helper

module SortHelper
  def sort_obj(sort_param, obj)
    case sort_param
    when 'id_asc'
      obj.order(id: :asc)
    when 'id_desc'
      obj.order(id: :desc)
    when 'uid_asc'
      obj.order(uid: :asc)
    when 'uid_desc'
      obj.order(uid: :desc)
    when 'name_asc'
      obj.order(name: :asc)
    when 'name_desc'
      obj.order(name: :desc)
    when 'time_asc'
      obj.order(created_at: :asc)
    when 'time_desc'
      obj.order(created_at: :desc)
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
    when 'item_uid_asc'
      obj.joins(:item).order('items.uid ASC')
    when 'item_uid_desc'
      obj.joins(:item).order('items.uid DESC')
    else
      obj.order(id: :asc)
    end
  end
end