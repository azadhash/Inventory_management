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
    # @item.id = generate_unique_id
    category = @item.category
    if @item.save
      @item.update(uid: generate_unique_id)
    # if category.present? && @item.category.required_quantity > category.items.count && @item.save
    #   category_count = category.required_quantity - category.items.count
    #   buffer_quantity = category.buffer_quantity
    #   if category_count <= buffer_quantity
    #     sent_notification_to_admin(category,'danger')
    #   elsif  category_count < buffer_quantity + 5
    #     sent_notification_to_admin(category,'warning')
    #   end
      redirect_to items_path, flash: { notice: "Item successfully created." }
    else
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
    @item.category_id = @item.category.id
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
    if !@item.user_id?
      @item.destroy
      render json: { success: "Item was successfully deleted." }, status: :ok
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
  def sent_notification_to_admin(category,priority_msg)
    User.get_admins.each do |admin|
      notification = Notification.create(recipient: admin,priority: priority_msg,message: "#{category.name} Category quantity is less than the buffer quantity")
      ActionCable.server.broadcast("AdminChannel", { notification: notification })
    end 
  end
  def item_params
    params.require(:item).permit(:name,:brand_id,:category_id,:user_id,:status,:notes,documents: [])
  end 
end
