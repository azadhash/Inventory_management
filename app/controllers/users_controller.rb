# frozen_string_literal: true

# this is the Users controller
class UsersController < ApplicationController
  before_action :current_user?
  before_action :user_type
  def index
    intialize_session
    session[:query] = nil
    @users = User.where.not(id: current_user.id)
    sort_param = params[:sort_by]
    @users = sort_obj(sort_param, @users)
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @items = @user.items
    sort_param = params[:sort_by]
    @items = sort_obj(sort_param, @items)
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to users_path, flash: { notice: 'User was successfully created.' }
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user, flash: { notice: 'User was successfully updated.' }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def search
    @users = search_obj(params, User)
    @users = @users.where.not(id: current_user.id)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    render json: { success: 'User was successfully deleted.' }, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :status, :admin)
  end
end
