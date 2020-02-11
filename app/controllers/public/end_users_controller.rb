class Public::EndUsersController < ApplicationController
  before_action :end_user_info
  before_action :authenticate_end_user!
  def show
  end

  def edit
  end

  def update
    if @end_user.update(end_user_params)
      redirect_to public_end_user_path(@end_user)
    else
      render :edit
    end
  end

  def destroy
    if @end_user.destroy
      redirect_to new_end_user_session_path
    else
      render :edit
    end
  end

  def status
  end

  private
  def end_user_info
    @end_user = EndUser.find(params[:id])
    if @end_user.id != current_end_user.id
      redirect_to public_end_user_path(current_end_user)
    end
  end

  def end_user_params
    params.require(:end_user).permit(:email)
  end
end
