class Public::OrdersController < ApplicationController
  before_action :nilCheck, only: [:done]

  def new
    @address = Address.new
    @addresses = Address.where(end_user_id: current_end_user.id)
    session[:order] = nil
  end

  def index
    @orders = Order.where(end_user_id: current_end_user.id)
  end

  def show
    @order_details = OrderDetail.where(order_id: params[:id])
  end

  def confirm
    @orders = []
    cart_items = CartItem.where(end_user_id: current_end_user.id)
    cart_items.each do |cart_item| 
      item = Item.find(cart_item.item_id)
      subtotal = item.price * cart_item.amount
      order_detail = OrderDetail.new(amount: cart_item.amount,
                                     subtotal: item.price * cart_item.amount)
      @orders.push([item.name, order_detail])
    end
  end

  def register
    postage = 800
    total_price = 0 + postage

    address_id = params[:address]
    address_id = address_id.to_i
    if address_id > 0
      address = Address.find(address_id)
    else
      recipient_name = current_end_user.last_name + current_end_user.first_name
      address = Address.new(recipient_name: recipient_name,
                            postal_code: current_end_user.postal_code,
                            address: current_end_user.address )
    end
    cart_items = CartItem.where(end_user_id: current_end_user.id)
    cart_items.each do |cart_item| 
      item = Item.find(cart_item.item_id)
      total_price += item.price * cart_item.amount
    end
    session[:order] = Order.new(total_price: total_price,
                                postage: postage,
                                payment_way: params[:payment_way],
                                recipient_name: address.recipient_name,
                                postal_code: address.postal_code,
                                address: address.address,
                                end_user_id: current_end_user.id)
    if session[:order]["payment_way"] == nil
      flash[:none] = "支払方法が選択されていません"
      redirect_to new_public_order_path
    else
      redirect_to public_orders_confirm_path
    end
  end

  def create_address
    @address = Address.new(address_params)
    @address.end_user_id = current_end_user.id
    @address.save
    redirect_to new_public_order_path
  end

  def create
    order = Order.new(total_price: session[:order]["total_price"],
                      postage: session[:order]["postage"],
                      payment_way:session[:order]["payment_way"],
                      recipient_name: session[:order]["recipient_name"],
                      postal_code: session[:order]["postal_code"],
                      address: session[:order]["address"],
                      end_user_id: session[:order]["end_user_id"])
    order.save
    
    cart_items = CartItem.where(end_user_id: current_end_user.id)
    cart_items.each do |cart_item| 
      item = Item.find(cart_item.item_id)
      subtotal = item.price * cart_item.amount
      order_detail = OrderDetail.new(amount: cart_item.amount,
                                     subtotal: item.price * cart_item.amount,
                                     order_id: order.id,
                                     item_id: item.id)
      order_detail.save
      cart_item.destroy
    end
    redirect_to public_orders_done_path
  end  

  private

  def address_params
    params.require(:address).permit(:recipient_name, :postal_code, :address, :end_user_id)
  end

  def nilCheck
    if session[:order] == nil
      redirect_to public_end_user_path(current_end_user)
    end
  end

end
