class UsersController < ApplicationController
  before_filter :user_from_url_param, only: [:edit, :update, :show, :destroy]
  before_action :load_user, only: :create
  load_and_authorize_resource

  def index
    if current_user.admin?
      @users = User.all.order(created_at: :desc)
    else
      @users = User.where(id: current_user.id)
    end
  end

  def new
    @user = User.new
  end

  def create
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
      if current_user.admin?
        redirect_to users_path
      else
        redirect_to edit_user_path(current_user)
      end
    else
      flash[:error] = @user.errors.full_messages[0]
      render 'edit'
    end
  end

  def destroy
    unless @user.admin?
      @user.destroy

      flash[:notice] = 'The User was successfully deleted'
      redirect_to users_path
    else

      flash[:error] = 'You can not destroy this user'
      redirect_to users_path
    end
  end

  private

  def load_user
    @user = User.new(user_params)
  end

  def user_params
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if current_user.admin?
      params.require(:user).permit(:email, :first_name, :last_name, :admin, :password, :password_confirmation)
    else
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
    end
  end

  def user_from_url_param
    @user = User.find(params[:id])
  end
end
