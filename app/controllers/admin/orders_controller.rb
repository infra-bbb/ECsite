class Admin::OrdersController < ApplicationController
  def index
    @orders = Order.all
  end

  def show
    @order = Order.find(params[:id])
    end_user = @order.end_user
    @order_name = end_user.last_name + " " + end_user.first_name
    @order_details = Array.new
    order_details = OrderDetail.where(order_id: params[:id])
    order_details.each do |order_detail|
      item = Item.find(order_detail.item_id)
      @order_details.push([item.name, order_detail])
    end
  end

  def update
    @order_detail = OrderDetail.find(params[:id])
    if @order_detail.update(order_detail_params)
      flash[:notice] = "製作ステータスを更新しました"
      redirect_to admin_order_path(@order_detail.order_id)
    end
  end

  def update_delivery
    @order = Order.find(params[:id])
    @order.status = params.dig(:order, :status)
    @order.save
    flash[:notice] = "注文ステータスを更新しました"
    redirect_to admin_order_path(@order)
  end

  private
  def order_detail_params
    params.require(:order_detail).permit(:status)
  end

  def order_params
    params.require(:order).permit(:status)
  end

end
