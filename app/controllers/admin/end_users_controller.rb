class Admin::EndUsersController < ApplicationController
  before_action :authenticate_admin!
  def index
    @end_users = EndUser.with_deleted
  end

  def show
  end

  def edit
  end

  def update
  end

  private
end
