class ItemsController < ApplicationController
  before_action :has_current_user
  before_action :user_type, except: [:index]
  def index
    if authenticate_user
      @items = Item.all
    else
      @items = current_user.items
    end
  end

  def new
    @items = Item.all
    @item = Item.new
  end
  
  def show
    @item = Item.find(params[:id])
  end

  def create
    @item = Item.create!(item_params)
    # @item.id = generate_unique_id
    if @item.save
      redirect_to items_path
    else
      render :new 
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])

    if @item.update(item_params)
      redirect_to items_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    redirect_to items_path, status: :see_other
  end

  def generate_unique_id
    loop do
      random_id = SecureRandom.random_number(10_000)
      return random_id if Item.find_by(id: random_id).nil?
    end
  end

  def item_params
    params.require(:item).permit(:name,:brand_id,:category_id,:user_id,:status,:notes,:document)
  end 
end
