# frozen_string_literal: true

# this is the items helper
module ItemsHelper
  def create_item
    category = @item.category
    if category.present? && category.required_quantity > category.items.count
      @item.uid = generate_unique_id
      @item.save
      send_notification
      redirect_to items_path, flash: { notice: 'Item successfully created.' }
    else
      flash[:alert] = 'Cannot create new item. Category required quantity is already met.'
      render :new
    end
  end

  def send_notification
    category = @item.category
    category_count = category.items.where(user_id: nil).count
    buffer_quantity = category.buffer_quantity
    msg = "you  have #{category_count} items in buffer in  #{category.name} category"
    if category_count < buffer_quantity
      sent_notification_to_admin(category, 'danger', msg)
    elsif category_count == buffer_quantity
      sent_notification_to_admin(category, 'warning', msg)
    end
  end

  def sent_notification_to_admin(_category, priority_msg, msg)
    User.get_admins.each do |admin|
      notifications = Notification.create(recipient: admin, priority: priority_msg, message: msg)
      ActionCable.server.broadcast('AdminChannel', { notification: notifications })
    end
  end

  def generate_unique_id
    loop do
      random_id = SecureRandom.random_number(10_000)
      return random_id if Item.find_by(id: random_id).nil?
    end
  end
end
