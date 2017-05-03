class OrdersController < ApplicationController

  require 'base64'

  include ChessStoreHelpers::Cart
  include ChessStoreHelpers::Shipping

  before_action :check_login
  before_action :set_order, only: [:show, :destroy]
  load_and_authorize_resource

  def index
    if logged_in? && !current_user.role?(:customer)
      @not_shipped_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(10)
      @all_orders = Order.all.chronological.paginate(:page => params[:page]).per_page(10)
    else
      @not_shipped_orders = current_user.orders.not_shipped.chronological.paginate(:page => params[:page]).per_page(10)
      @all_orders = current_user.orders.chronological.paginate(:page => params[:page]).per_page(10)
    end
  end

  def show
    @order_items = @order.order_items.to_a
  end

  def new
    @order = Order.new
  end

  def edit
    @order = Order.find(params[:id])
  end

  def create
    @order = Order.new(order_params)

    @order.credit_card_number = params[:order][:credit_card_number]
    @order.expiration_year = params[:order][:expiration_year]
    @order.expiration_month = params[:order][:expiration_month]
    @order.user_id = current_user.id
    @order.grand_total = calculate_cart_shipping + calculate_cart_items_cost
    @order.date = Date.current

    if @order.save
      save_each_item_in_cart(@order)

      receipt = @order.pay
      @payment_info = Base64.decode64(receipt)[-13..-1].to_s
      clear_cart
      redirect_to @order, notice: "Thank you for ordering from the Chess Store."
    else
      render action: 'new'
    end
  end

  def update
    if @order.update(order_params)
      redirect_to order_path(@order), notice: "Your order was revised in the system."
    else
      render action: 'edit'
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: "This order was removed from the system."
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:school_id, :credit_card_number, :expiration_year, :expiration_month)
  end

end