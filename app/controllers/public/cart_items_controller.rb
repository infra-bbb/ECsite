class Public::CartItemsController < ApplicationController
  before_action :cart_item_info, only: [:destroy, :update]
  before_action :authenticate_end_user!, only: [:create, :index]
  before_action :blank_check, only: [:create]

  def index
    @cart_items = {}
    cart_items = CartItem.where(end_user_id: current_end_user.id)
    cart_items.each do |cart_item|
      item = Item.find(cart_item.item_id)
      @cart_items[item.name] = cart_item
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    redirect_to public_cart_items_path
  end

  def destroy
    @cart_item.destroy
    redirect_to public_cart_items_path
  end

  def destroy_all
    cart_items = CartItem.where(end_user_id: current_end_user.id)
    cart_items.each do |cart_item|
      cart_item.destroy
    end
    redirect_to public_end_user_path(current_end_user)
  end

  def create
    existed_cart_item = CartItem.where(item_id: params[:item_id]).where(end_user_id: current_end_user.id)
    if existed_cart_item.empty?
      @cart_item = CartItem.new(cart_item_params)
      @cart_item.end_user_id = current_end_user.id
      @cart_item.item_id = params[:item_id]
      @cart_item.save
      redirect_to public_cart_items_path
    else
      flash[:error] = "既に追加されています"
      redirect_to public_cart_items_path
    end
  end

  private
  def cart_item_params
    params.require(:cart_item).permit(:amount, :item_id, :end_user_id)
  end

  def cart_item_info
    @cart_item = CartItem.find(params[:id])
  end

  def blank_check
    amount = params.dig(:cart_item, :amount)
    if amount == ""
      flash[:error] = "数をしてしてください"
      redirect_to public_item_path(params[:item_id])
    end
  end
end
