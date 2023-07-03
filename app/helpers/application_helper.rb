module ApplicationHelper
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  def authenticate_user
    current_user&.admin
  end

  # def submit_button
  #   <div class="d-flex justify-content-center">
  #   <%= form.submit class: 'btn btn-primary mt-5  custom-bg-color' %>
  #   </div>
  # end
end
