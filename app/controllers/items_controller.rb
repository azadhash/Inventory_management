# frozen_string_literal: true

# this is the Items controller
class ItemsController < ApplicationController
  include ItemsHelper
  before_action :current_user?
  before_action :user_type, except: %i[index show search]
  before_action :fetch_item, only: %i[show edit update destroy]

  def index
    intialize_session
    session[:query] = nil
    @items = if authenticate_user
               Item.all
             else
               current_user.items
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
    if @item.update(item_params)
      send_notification
      redirect_to items_path, flash: { notice: 'Item was successfully updated.' }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if !@item.user_id?
      if @item.destroy
        render json: { success: 'Item was successfully deleted.' }, status: :ok
      else
        render json: { error: 'An error occurred while deleting the item.' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Item was allocated to a user.' }, status: :unprocessable_entity
    end
  end

  def search
    @items = search_obj(params, Item)
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
