class SessionsController < ApplicationController

  include ChessStoreHelpers::Cart
  
  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      if user.role?(:admin) || user.role?(:customer)
        create_cart
      end
      redirect_to root_url, notice: "Welcome, #{user.first_name}!"
    else
      flash[:error] = "Username or password is invalid."
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    destroy_cart
    redirect_to root_url, notice: "Logged out."
  end
  
end