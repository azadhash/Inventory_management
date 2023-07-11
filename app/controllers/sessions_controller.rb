class SessionsController < ApplicationController
   
  def new
    logged_in
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      @user.update(token: generate_token)
      UserMailer.welcome_email(@user).deliver_later
      render :new, flash: { notice: 'Magic link sent to your email.' }
    else
      render :new, flash: { alert: 'User not found.' }
    end
  end

  def authenticate
    token = params[:token]
    expiry_time = params[:expiry_time]
    user = User.find_by(token: token)
   
    if expiry_time > Time.now && user
      session[:user_id] = user.id
      cookies.signed[:user_id] = user.id 
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
    user = User.find_by(email: request.env['omniauth.auth'][:info][:email]) 
    if user && user.status
      session[:user_id] = user.id
      cookies.signed[:user_id] = user.id 
      redirect_to dashboard_path, flash: { notice: 'Logged in successfully.' }
    else
      redirect_to login_path, flash: { alert: 'User not found.' }
    end
  end
  private
  def generate_token
    SecureRandom.hex(16)
  end

end
