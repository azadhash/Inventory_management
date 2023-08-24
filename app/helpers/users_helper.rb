# frozen_string_literal: true

# this is the Issues helper
module UsersHelper
  def update_user
    if @user.update(user_params)
      redirect_to @user, flash: { notice: 'User was successfully updated.' }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def check_user
    return unless @user == current_user

    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end
end
