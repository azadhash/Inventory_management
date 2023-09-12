# frozen_string_literal: true

# this is the Brands controller
class BrandsController < ApplicationController
  before_action :current_user?
  before_action :admin?
  before_action :fetch_brand, only: %i[edit update destroy]
  def index
    session[:query] = nil
    @brands = Brand.all
    sort_param = params[:sort_by]
    @brands = sort_obj(sort_param, @brands)
    @brands = @brands.page(params[:page]).per(5)
  end

  def new
    @brand = Brand.new
  end

  def create
    @brand = Brand.new(brand_params)
    if @brand.save
      redirect_to brands_path, flash: { notice: 'Brand successfully created.' }
    else
      render :new
    end
  end

  def edit; end

  def update
    if @brand.update(brand_params)
      redirect_to brands_path, flash: { notice: 'Brand was successfully updated.' }
    else
      render 'edit'
    end
  end

  def search
    @brands = search_obj(params, Brand)
    @brands = @brands.page(params[:page]).per(5)
  end

  def destroy
    if !@brand.items.present?
      @brand.destroy
      redirect_to brands_path, flash: { notice: 'Brand was successfully deleted.' }
    else
      redirect_to brands_path, flash: { alert: "#{@brand.name} brand cannot be deleted.
                                        There are items in this brand." }
    end
  end

  private

  def fetch_brand
    @brand = Brand.find(params[:id])
  end

  def brand_params
    params.require(:brand).permit(:name)
  end
end
