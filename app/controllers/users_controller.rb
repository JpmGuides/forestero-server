class UsersController < ApplicationController
  before_filter :user_from_url_param, only: [:edit, :update, :show]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = 'The User is successfully saved!'
      redirect_to users_path
    else
      flash[:error] = @user.errors.full_messages[0]
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'The User is successfully updated!'
      redirect_to users_path
    else
      flash[:error] = @user.errors.full_messages[0]
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def user_from_url_param
    @user = User.find(params[:id])
  end
end
