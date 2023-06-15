class BrandsController < ApplicationController
  before_action :has_current_user
  before_action :user_type
  def index
    @brands = Brand.all
  end

  def new
    @brand = Brand.new
  end
  
  # def show
  #   @brand = Brand.find(params[:id])
  # end

  def create
    @brand = Brand.new(brand_params)

    if @brand.save
      redirect_to brands_path
    else
      render :new 
    end
  end

  def edit
    @brand = Brand.find(params[:id])
  end

  def update
    @brand = Brand.find(params[:id])

    if @brand.update(brand_params)
      redirect_to brands_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy

    redirect_to brands_path, status: :see_other
  end

  def brand_params
    params.require(:brand).permit(:name)
  end 
end
