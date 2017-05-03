class UsersController < ApplicationController

  include ChessStoreHelpers::Cart

  before_action :set_user, only: [:show, :edit, :update]
  load_and_authorize_resource

  def index
    @active_users = User.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_users = User.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    @employees = User.employees.alphabetical.paginate(page: params[:page]).per_page(10)
    @customers = User.customers.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def new
    @user = User.new
    unless logged_in? && (current_user.role?(:manager) || current_user.role?(:admin))
      session[:user_id] = @user.id
    end
  end

  def edit
  end

  def show
    @user_orders = @user.orders.all.chronological.paginate(page: params[:page]).per_page(10)
    @reformatted_phone = "(#{@user.phone[0..2]}) #{@user.phone[3..5]}-#{@user.phone[6..9]}"
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if !logged_in?
        session[:user_id] = @user.id
        create_cart
        redirect_to home_path, notice: "Welcome, #{@user.first_name}. Thank you for signing up!"
      else
        redirect_to user_path(@user), notice: "Successfully created #{@user.proper_name}."
      end
    else
      flash[:error] = "This user could not be created."
      render "new"
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = "#{@user.proper_name} was successfully updated."
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
    if current_user && (current_user.role?(:admin) || current_user.role?(:manager))
      params.require(:user).permit(:first_name, :last_name, :email, :phone, :username, :password, :password_confirmation, :role, :active) 
    else
      params.require(:user).permit(:first_name, :last_name, :email, :phone, :username, :password, :password_confirmation, :role) 
    end
  end

end