class BrandsController < ApplicationController
  before_action :has_current_user
  before_action :user_type
  def index
    session[:query] = nil
    @brands = Brand.all
    sort_param = params[:sort_by]
    @brands = sort_obj(sort_param,@brands)
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

  def search
    query = params[:search_categories].presence && params[:search_categories][:query]
    #  query.to_i.to_s == query ? query.to_i : query
    if query
      session[:query] = query
      @brands = Brand.search_brand(query).records 
    elsif session[:query]
      @brands = Brand.search_brand(session[:query]).records
    end
    sort_param = params[:sort_by]
    @brands = sort_obj(sort_param,@brands)
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
