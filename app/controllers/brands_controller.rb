# frozen_string_literal: true

# this is the Brands controller
class BrandsController < ApplicationController
  before_action :current_user?
  before_action :user_type
  def index
    session[:query] = nil
    @brands = Brand.all
    sort_param = params[:sort_by]
    @brands = sort_obj(sort_param, @brands)
    @brand = Brand.new
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

  def edit
    @brand = Brand.find(params[:id])
  end

  def update
    @brand = Brand.find(params[:id])
    if @brand.update(brand_params)
      redirect_to brands_path, flash: { notice: 'Brand was successfully updated.' }
    else
      flash.now[:alert] = 'Brand was not updated.'
      render 'edit'
    end
  end

  def search
    @brands = search_obj(params, Brand)
  end

  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy
    render json: { success: 'Brand was successfully deleted.' }, status: :ok
  end

  private

  def brand_params
    params.require(:brand).permit(:name)
  end
end
