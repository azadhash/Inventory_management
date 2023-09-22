# frozen_string_literal: true

# this is the items helper
module ItemsHelper
  def create_item
    category = @item.category
    if category.present? && category.items.count < category.total_items
      @item.uid = generate_unique_id
      @item.save
      check_user('created')
    else
      flash.now[:alert] = "Cannot create new item. We don't need more item in #{@item.category.name} category."
      render :new
    end
  end

  def send_notification
    category = @item.category
    item_count = category.count_allocated_items
    buffer_quantity = category.buffer_quantity + category.required_quantity - category.expected_buffer
    msg = "In #{category.name.capitalize} category, the number of items
           is below the expected buffer quantity by #{item_count - buffer_quantity}."
    return unless item_count > buffer_quantity

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

  def check_user(action)
    if @item.user_id.present?
      send_notification
      redirect_to @item, flash: { notice: "#{@item.category.name} successfully allocated to #{@item.user.name}" }
    else
      flash_message = action == 'created' ? 'Item created successfully.' : 'Item updated successfully.'
      redirect_to @item, flash: { notice: flash_message }
    end
  end

  def check_show
    return if authenticate_user
    return unless @item.user_id != current_user.id

    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  def generate_unique_id
    loop do
      random_id = SecureRandom.random_number(10_000)
      return random_id if Item.find_by(id: random_id).nil?
    end
  end

  def back_btn
    session[:back] == 'user' ? user_path(@item.user) : items_path
  end
end
