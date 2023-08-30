# frozen_string_literal: true

# this is the Items controller
class ItemsController < ApplicationController
  include ItemsHelper
  before_action :current_user?
  before_action :admin?, except: %i[index show search]
  before_action :fetch_item, only: %i[show edit update destroy]
  before_action :check_show, only: %i[show]
  def index
    initialize_session
    session[:query] = nil
    @items = if authenticate_user
               Item.includes(:brand, :category, :user).all
             else
               current_user.items.includes(:brand, :category)
             end
    sort_param = params[:sort_by]
    @items = sort_obj(sort_param, @items)
    @items = @items.page(params[:page]).per(5)
  end

  def new
    @item = Item.new
  end

  def show; end

  def create
    @item = Item.new(item_params)

    if @item.valid?
      create_item
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @item.category_id = @item.category.id
  end

  def update
    @category = @item.category
    if @item.update(item_params)
      check_catgeory
      redirect_to @item, flash: { notice: 'Item was successfully updated.' }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def check_catgeory
    if @category.id != @item.category_id
      update_category
    else
      send_notification
    end
  end

  def destroy
    if !@item.user_id?
      @category = @item.category
      @category.update(required_quantity: @category.required_quantity + 1)
      redirect_to items_path, flash: { notice: 'Item was successfully deleted.' } if @item.destroy
    else
      redirect_to items_path, flash: { alert: 'We can not delete this item as item is allocated to a user.' }
    end
  end

  def search
    @items = search_obj(params, Item)
    fetch_item_of_employee
    @items = @items.page(params[:page]).per(5)
  end

  def clear_filter
    session[:category_id] = nil
    session[:brand_id] = nil
    session[:status] = nil
    @items = search_obj(params, Item)
    fetch_item_of_employee
    @items = @items.page(params[:page]).per(5)
  end

  private

  def fetch_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :brand_id, :category_id, :user_id, :status, :notes, documents: [])
  end
end
