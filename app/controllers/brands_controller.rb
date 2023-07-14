# frozen_string_literal: true

# this is the Brands controller
class BrandsController < ApplicationController
  before_action :current_user?
  before_action :user_type
  before_action :fetch_brand, only: %i[edit update destroy]
  def index
    session[:query] = nil
    @brands = Brand.all
    sort_param = params[:sort_by]
    @brands = sort_obj(sort_param, @brands)
    @brand = Brand.new
    @brands = @brands.page(params[:page]).per(5)
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)
    @brand.save
    respond_to do |format|
      format.js { flash.now[:notice] = 'Brand was successfully created.' }
    end
  end

  def edit; end

  def update
    if @brand.update(brand_params)
      redirect_to brands_path, flash: { notice: 'Brand was successfully updated.' }
    else
      flash.now[:alert] = 'Brand was not updated.'
      render 'edit'
    end
  end

  def search
    @brands = search_obj(params, Brand)
    @brands = @brands.page(params[:page]).per(5)
  end

  def destroy
    @brand.destroy
    render json: { success: 'Brand was successfully deleted.' }, status: :ok
  end

  private

  def fetch_brand
    @brand = Brand.find(params[:id])
  end

  def brand_params
    params.require(:brand).permit(:name)
  end
end
