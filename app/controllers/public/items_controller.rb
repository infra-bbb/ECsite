class Public::ItemsController < ApplicationController
  def index
    @items = Item.search(params[:search])
  end

  def root
  end

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
  end
end
