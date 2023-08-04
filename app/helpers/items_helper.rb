# frozen_string_literal: true

# this is the items helper
module ItemsHelper
  def create_item
    category = @item.category
    if category.present? && category.required_quantity.positive?
      @item.uid = generate_unique_id
      @item.save
      update_category
      redirect_to items_path, flash: { notice: 'Item successfully created.' }
    else
      flash.now[:alert] = "Cannot create new item. We don't need more item in #{@item.category.name} category."
      render :new
    end
  end

  def update_category
    @category = @item.category
    @category.update(required_quantity: @category.required_quantity - 1)
    send_notification
  end

  def send_notification
    category = @item.category
    category_count = category.items.where(user_id: nil).count
    buffer_quantity = category.buffer_quantity
    msg = "You  Have #{category_count} Items in Buffer in  #{category.name.capitalize} Category"
    return unless category_count + category.required_quantity < buffer_quantity

    sent_notification_to_admin(category.priority, msg)
  end

  def sent_notification_to_admin(priority_msg, msg)
    User.get_admins.each do |admin|
      @notifications = Notification.create(recipient: admin, priority: priority_msg, message: msg)
    end
    ActionCable.server.broadcast('AdminChannel', { notification: @notifications })
  end

  def fetch_item_of_employee
    return if authenticate_user

    @items = @items.where(user_id: current_user.id)
  end

  def generate_unique_id
    loop do
      random_id = SecureRandom.random_number(10_000)
      return random_id if Item.find_by(id: random_id).nil?
    end
  end
end
