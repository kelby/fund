class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:account]

  def show
    @user = User.find(params[:id])

    if current_user?(@user)
      redirect_to account_path
    end
  end

  def account
    @user = current_user
  end
end
