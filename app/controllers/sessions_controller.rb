# frozen_string_literal: true

# this is the Sessions controller
class SessionsController < ApplicationController
  def new
    logged_in
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user&.active
      @user.update(token: generate_token)
      UserMailer.welcome_email(@user).deliver_later
      flash[:notice] = 'Magic link sent to your email.'
    else
      flash_for_invalid_login
    end
    render :new
  end

  def authenticate
    token = params[:token]
    expiry_time = params[:expiry_time]
    user = User.find_by_token(token)

    if expiry_time > Time.now && user
      self.current_user = user
      redirect_to dashboard_path, flash: { notice: 'Logged in successfully.' }
    else
      redirect_to login_path, flash: { alert: 'Magic link expired' }
    end
  end

  def destroy
    session.delete :user_id
    cookies.delete :user_id
    redirect_to login_path, flash: { notice: 'Logged out successfully.' }
  end

  def omniauth
    @user = User.find_by(email: request.env['omniauth.auth'][:info][:email])
    if @user&.active
      self.current_user = @user
      redirect_to dashboard_path, flash: { notice: 'Logged in successfully.' }
    else
      flash_for_invalid_login
      redirect_to login_path
    end
  end

  def current_user=(user)
    session[:user_id] = user.id
    cookies.signed[:user_id] = user.id
  end

  private

  def flash_for_invalid_login
    flash[:alert] = if @user&.active == false
                      'Account is not active.'
                    else
                      'User not found.'
                    end
  end

  def generate_token
    SecureRandom.hex(16)
  end
end
