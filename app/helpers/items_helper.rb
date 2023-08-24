# frozen_string_literal: true

# this is the items helper
module ItemsHelper
  def create_item
    category = @item.category
    if category.present? && category.required_quantity.positive?
      @item.uid = generate_unique_id
      @item.save
      update_category
      check_user
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
    category_count = category.items.where(user_id: nil).count + category.required_quantity
    buffer_quantity = category.buffer_quantity
    msg = "In #{category.name.capitalize} category, items required is less than expected buffer by
            #{buffer_quantity - category_count}"
    return unless category_count < buffer_quantity

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

  def check_user
    if @item.user_id.present?
      redirect_to @item, flash: { notice: "#{@item.category.name} successfully allocated to #{@item.user.name}" }
    else
      redirect_to @item, flash: { notice: 'Item created successfully.' }
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
end
