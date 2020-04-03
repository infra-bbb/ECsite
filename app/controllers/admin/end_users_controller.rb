class Admin::EndUsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_end_user, except: [:index]

  def index
    @end_users = EndUser.with_deleted
  end

  def show
  end

  def edit
  end

  def update
    if @end_user.update(end_user_params)
      # byebug
      if params[:end_user][:status] == "0"
        @end_user.restore
      elsif params[:end_user][:status] == "1"
        @end_user.destroy
      end
      redirect_to admin_end_user_path(@end_user)
    else
      render :edit
    end
  end

  private
  def set_end_user
    @end_user = EndUser.with_deleted.find(params[:id])
  end

  def end_user_params
    params.require(:end_user).permit(:first_name, :last_name,
                                     :first_name_kana, :last_name_kana,
                                     :postal_code, :address, :phone_number,
                                     :email, :status)
  end
end
