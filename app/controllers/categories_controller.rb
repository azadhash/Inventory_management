# frozen_string_literal: true

# this is the Categories controller
class CategoriesController < ApplicationController
  before_action :current_user?
  before_action :user_type
  before_action :fetch_category, only: %i[edit update destroy]
  def index
    session[:query] = nil
    @categories = Category.all
    sort_param = params[:sort_by]
    @categories = sort_obj(sort_param, @categories)
    @categories = @categories.page(params[:page]).per(5)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_path, flash: { notice: 'Category successfully created.' }
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to categories_path, flash: { notice: 'Category successfully updated.' }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    render json: { success: 'Catgeory was successfully deleted.' }, status: :ok
  end

  def storage
    @categories = Category.all
  end

  def search
    @categories = search_obj(params, Category)
    @categories = @categories.page(params[:page]).per(5)
  end

  def fetch_data
    category = Category.find(params[:category_id])
    storage = category.required_quantity - category.items.count
    render json: { storage: }
  end

  private

  def fetch_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :required_quantity, :buffer_quantity)
  end
end
