class CategoriesController < ApplicationController
  before_action :has_current_user
  before_action :user_type
  def index
    session[:query] = nil
    @categories = Category.all
    sort_param = params[:sort_by]
    @categories = sort_obj(sort_param,@categories)
  end

  def new
    @category = Category.new
  end
  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_path, flash: { notice: "Category successfully created." }
    else
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])

    if @category.update(category_params)
      redirect_to categories_path, flash: { notice: "Category successfully updated." }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    render json: { success: "Catgeory was successfully deleted." }, status: :ok
  end

  def storage
    @categories = Category.all
  end
  
  def search
    query = params[:search_categories].presence && params[:search_categories][:query]
    # query.to_i.to_s == query ? query.to_i : query
    if query
      session[:query] = query
      @categories = Category.search_category(query).records 
    elsif  session[:query]
      @categories = Category.search_category( session[:query]).records
    end
    sort_param = params[:sort_by]
    @categories = sort_obj(sort_param,@categories)
  end    
  
  def fetch_data
   category = Category.find(params[:category_id])
   storage = category.required_quantity - category.items.count
   render json: { storage: storage }
  end
  private
  def category_params
    params.require(:category).permit(:name,:required_quantity,:buffer_quantity)
  end 
end
