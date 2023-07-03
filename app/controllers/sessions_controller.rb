class SessionsController < ApplicationController
   
  def new
    logged_in
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      @user.update(token: generate_token)
      UserMailer.welcome_email(@user).deliver_now
      flash[:notice] = 'Magic link sent to your email!'
      render :new
    else
      flash[:alert] = 'User not found.'
      render :new
    end
  end

  def authenticate
    token = params[:token]
    expiry_time = params[:expiry_time]
    user = User.find_by(token: token)
   
    if user && expiry_time > Time.now
      session[:user_id] = user.id
      cookies.signed[:user_id] = user.id 
      redirect_to dashboard_path
    else
      user.update(token: nil)
      flash[:info] = 'Token expired. Please login again.'
      redirect_to login_path
    end
  end

  def destroy
    session.delete :user_id
    redirect_to login_path
  end

  def omniauth
    user = User.find_by(email: request.env['omniauth.auth'][:info][:email]) 
    if user
      session[:user_id] = user.id
      cookies.signed[:user_id] = user.id 
      redirect_to dashboard_path
    else
      redirect_to login_path
    end
  end
  private
  def generate_token
    SecureRandom.hex(16)
  end

end
