class SessionsController < ApplicationController

  include ChessStoreHelpers::Cart

  def new
    create_cart
  end
  
  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: "Welcome, #{user.first_name}!"
    else
      flash[:alert] = "Username or password is invalid"
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    destroy_cart
    redirect_to root_url, notice: "Logged out."
  end
end