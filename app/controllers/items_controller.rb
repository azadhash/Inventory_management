class ItemsController < ApplicationController
  before_action :has_current_user
  before_action :user_type, except: [:index,:show,:search]
 
  def index
    intialize_session
    session[:query] = nil
    if authenticate_user
      @items = Item.all
    else
      @items = current_user.items
    end
    sort_param = params[:sort_by]
    @items = sort_obj(sort_param,@items)
  end

  def new
    @item = Item.new
  end
  
  def show
    @item = Item.find(params[:id])
  end

  def create
    @item = Item.new(item_params)
    category = @item.category
    binding.pry
    if @item.valid?
      if category.present? && category.required_quantity > category.items.count 
        @item.save
        @item.update(uid: generate_unique_id)
        category_count = category.items.where(user_id: nil).count 
        buffer_quantity = category.buffer_quantity
        msg = "you  have #{category_count} items in buffer in  #{category.name} category"
        if category_count < buffer_quantity
          sent_notification_to_admin(category,'danger',msg)
        elsif  category_count == buffer_quantity
          sent_notification_to_admin(category,'warning',msg)
        end
        redirect_to items_path, flash: { notice: "Item successfully created." }
      else
        flash[:alert] = "Cannot create new item. Category required quantity is already met."
        render :new
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @item = Item.find(params[:id])
    @item.category_id = @item.category.id
  end

  def update
    @item = Item.find(params[:id])
     if @item.update(item_params)
      redirect_to items_path, flash: { notice: "Item was successfully updated." }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item = Item.find(params[:id])
    if !@item.user_id?
      if @item.destroy
        render json: { success: "Item was successfully deleted." }, status: :ok
      else
        render json: { error: "An error occurred while deleting the item." }, status: :unprocessable_entity
      end
    else
      render json: { error: "Item was allocated to a user." }, status: :unprocessable_entity
    end
  end
  

  def search
    @items = search_obj(params,Item)
  end

  def generate_unique_id
    loop do
      random_id = SecureRandom.random_number(10_000)
      return random_id if Item.find_by(id: random_id).nil?
    end
  end
  def sent_notification_to_admin(category,priority_msg,msg)
    User.get_admins.each do |admin|
      notification = Notification.create(recipient: admin,priority: priority_msg,message: msg)
      ActionCable.server.broadcast("AdminChannel", { notification: notification })
    end 
  end
  def item_params
    params.require(:item).permit(:name,:brand_id,:category_id,:user_id,:status,:notes,documents: [])
  end 
end
