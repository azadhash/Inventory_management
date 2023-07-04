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
    if @item.category.required_quantity > category.items.count && @item.save
      category_count = category.required_quantity - category.items.count
      buffer_quantity = category.buffer_quantity
      if category_count <= buffer_quantity
        sent_notification_to_admin(category,'danger')
      elsif  category_count < buffer_quantity + 5
        sent_notification_to_admin(category,'warning')
      end
      redirect_to items_path
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
    end
    redirect_to items_path, status: :see_other
  end

  def search
    query = params[:search_categories].presence && params[:search_categories][:query]
    # query.to_i.to_s == query ? query.to_i : query
    if query
      session[:query] = query
      @items = Item.search_item(query).records 
    elsif  session[:query]
      @items = Item.search_item( session[:query]).records
    else
      @items = Item.all
    end
    if params[:filter]
      intialize_session
    end 
    @items = filter(@items)
    sort_param = params[:sort_by]
    @items = sort_obj(sort_param,@items)
  end
  
  def filter(obj)
    if session[:category_id].present?
      obj = obj.where(category_id: session[:category_id])
    end
    if session[:brand_id].present?
      obj = obj.where(brand_id: session[:brand_id])
    end
    if session[:status].present?
      obj = obj.where(status: session[:status])
    end
    obj
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
