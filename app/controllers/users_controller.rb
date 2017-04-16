class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update]
  authorize_resource

  def index
    @users = User.all.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def new
    @user = User.new
    session[:user_id] = @user.id
  end

  def edit
  end

  def show
    @user_orders = @user.orders.all.chronological.paginate(page: params[:page]).per_page(10)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to home_path, notice: "Thank you for signing up!"
    else
      flash[:alert] = "This user could not be created."
      render "new"
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "#{@user.proper_name} is updated."
      redirect_to @user
    else
      render :action => 'edit'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    if current_user && current_user.role?(:admin)
      params.require(:user).permit(:first_name, :last_name, :email, :phone, :username, :password, :password_confirmation, :role, :active) 
    elsif current_user && current_user.role?()
    end
  end

end