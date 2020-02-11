class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!
  before_action :genre_info, only: [:edit, :update]

  def index
  	@genre = Genre.new
  	@genres = Genre.all
  end

  def create
  	@genre = Genre.new(genre_params)
  	@genre.save
  	redirect_to admin_genres_path
  end

  def edit
  end

  def update
  	if @genre.update(genre_params)
  	  redirect_to admin_genres_path
  	else
  	  redirect_to edit_admin_genre_path(@genre)
  	end
  end

  private

  def genre_params
  	params.require(:genre).permit(:name, :status)
  end

  def genre_info
  	@genre = Genre.find(params[:id])
  end
end
