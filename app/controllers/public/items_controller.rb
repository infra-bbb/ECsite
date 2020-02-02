class Public::ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def root
  end

  def show
  end
end
