class Public::OrdersController < ApplicationController
  before_action :nilCheck, only: [:done]

  def new
    session[:order] = Order.new
  end

  def confirm
    @cart_items = {}
    @total = 0
    @postage = 800
    cart_items = CartItem.where(end_user_id: current_end_user.id)
    cart_items.each do |cart_item|
      item = Item.find(cart_item.item_id)
      @cart_items[item] = cart_item
    end
  end

  def done
    postage = 800
    cart_items = CartItem.where(end_user_id: current_end_user.id)
    total_price = 0

    # make order info
    cart_items.each do |cart_item|
      item = Item.find(cart_item.item_id)
      total_price += item.price * cart_item.amount
    end
    total_price += postage
    @order = Order.new(total_price: total_price,
                       postage: postage,
                       payment_way: session[:order]["payment_way"],
                       recipient_name: session[:address]["recipient_name"],
                       postal_code: session[:address]["postal_code"],
                       address: session[:address]["address"],
                       end_user_id: current_end_user.id)
    @order.save

    # make order_detrail info
    cart_items.each do |cart_item|
      item = Item.find(cart_item.item_id)
      order_detail = OrderDetail.new(amount: cart_item.amount,
                                     subtotal: cart_item.amount * item.price,
                                     order_id: @order.id,
                                     item_id: item.id)
      order_detail.save
      cart_item.destroy
    end

    # make Address info
    if session[:newAddress] == 1
      address = Address.new(recipient_name: session[:address]["recipient_name"], 
                            postal_code: session[:address]["postal_code"],
                            address: session[:address]["address"],
                            end_user_id: current_end_user.id)
      address.save
    end
    session[:order] = nil
    session[:address] = nil
    session[:newAddress] = nil
  end

  def pay
    keys = params[:pre_payment]
    session[:order][:payment_way] = Order.payment_ways.keys[keys.to_i]
    @addresses = Address.where(end_user_id: current_end_user.id)
    @order = Order.new
    render :new
  end

  def create
    postage = 800
    total_price = 0
    session[:address] = Address.new(recipient_name: params[:recipient_name], 
                                    postal_code: params[:postal_code],
                                    address: params[:address])
    if session[:address]["recipient_name"] == "" or session[:address]["postal_code"] == "" or session[:address]["address"] == ""
      flash[:anomaly] = "配送先に未入力のものがあります"
      # render :new
      redirect_to new_public_order_path
    else
      session[:newAddress] = 1
      redirect_to public_orders_confirm_path
    end
  end

  def register
    if params[:id] == "0"
      recipient_name = current_end_user.last_name + current_end_user.first_name
      session[:address] = Address.new(recipient_name: recipient_name,
                                      postal_code: current_end_user.postal_code,
                                      address: current_end_user.address)
    else
      address = Address.find(params[:id])
      session[:address] = Address.new(recipient_name: address.recipient_name,
                                      postal_code: address.postal_code,
                                      address: address.address)
    end
    session[:newAddress] = 0
    redirect_to public_orders_confirm_path
  end

  def index
    @orders = Order.where(end_user_id: current_end_user.id)
  end

  def show
    @order_details = OrderDetail.where(order_id: params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:recipient_name, :postal_code, :address, :payment_way)
  end

  def nilCheck
    if session[:order] == nil
      redirect_to public_end_user_path(current_end_user)
    end
  end

end
