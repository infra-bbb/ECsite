class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!
  before_action :item_info, only: [:show, :edit, :update]
  
  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_items_path
    else
      @items = Item.all
      render :new
    end
  end

  def index
    @items = Item.all
    # items = Item.all
    # items.each do |item|
    #   genre = Genre.find(item.genre_id)
    #   @items.push([genre.name, item])
    # end
  end

  def show
  end

  def edit
  end

  def update
    @item.update(item_params)
    redirect_to admin_items_path
  end

  private
  def item_params
    params.require(:item).permit(:name, :price, :genre_id, :status)
  end

  def item_info
    @item = Item.find(params[:id])
  end
end
