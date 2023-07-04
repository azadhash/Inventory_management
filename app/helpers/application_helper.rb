module ApplicationHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  def authenticate_user
    current_user&.admin
  end

  def sort_obj(sort_param , obj)
    case sort_param
    when "id_asc"
      obj = obj.order(id: :asc)
    when "id_desc"
      obj = obj.order(id: :desc)
    when "name_asc"
      obj = obj.order(name: :asc)
    when "name_desc"
      obj = obj.order(name: :desc)
    when "user_name_asc"
      obj = obj.joins(:user).order("users.name ASC")
    when "user_name_desc"
      obj = obj.joins(:user).order("users.name DESC")  
    when "user_id_asc"
      obj = obj.order(user_id: :asc)
    when "user_id_desc"
      obj = obj.order(user_id: :desc)
    when "brand_asc"
      obj = obj.joins(:brand).order("brands.name ASC")
    when "brand_desc"
      obj = obj.joins(:brand).order("brands.name DESC")  
    when "category_asc"
      obj = obj.joins(:category).order("categories.name ASC")  
    when "category_desc"
      obj = obj.joins(:category).order("categories.name DESC")  
    else
      # Default sorting if no sort parameter is provided
      obj = obj.order(id: :asc)
    end
  end 
  # def submit_button
  #   <div class="d-flex justify-content-center">
  #   <%= form.submit class: 'btn btn-primary mt-5  custom-bg-color' %>
  #   </div>
  # end
end
