class Public::ItemsController < ApplicationController

  def root
  end

  def index
    if params[:item].present?
      @items = Item.search(params[:item][:name])
    else
      @items = Item.all      
    end
  end

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
  end
end
