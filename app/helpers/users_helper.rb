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
end
