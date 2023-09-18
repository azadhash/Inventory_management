# frozen_string_literal: true

# this is the Categories controller
class CategoriesController < ApplicationController
  before_action :current_user?
  before_action :admin?
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
    if !@category.items.present?
      @category.destroy
      redirect_to categories_path, flash: { notice: 'Category was successfully deleted.' }
    else
      redirect_to categories_path, flash: { alert: "#{@category.name} category cannot be deleted.
                                                    There are items in this category." }
    end
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
    storage = category.count_user_id_nil
    render json: { storage: }
  end

  private

  def fetch_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :required_quantity, :buffer_quantity, :priority)
  end
end
