# frozen_string_literal: true

# this is the Items controller
class ItemsController < ApplicationController
  include ItemsHelper
  before_action :current_user?
  before_action :user_type, except: %i[index show search]

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
  end

  def new
    @item = Item.new
  end

  def show
    @item = Item.find(params[:id])
  end

  def create
    @item = Item.new(item_params)

    if @item.valid?
      create_item
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
      redirect_to items_path, flash: { notice: 'Item was successfully updated.' }
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item = Item.find(params[:id])
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
  end

  private

  def item_params
    params.require(:item).permit(:name, :brand_id, :category_id, :user_id, :status, :notes, documents: [])
  end
end
