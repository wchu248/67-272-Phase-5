class HomeController < ApplicationController
  def home
    if logged_in? && (current_user.role?(:shipper) || current_user.role?(:admin))
      @not_shipped_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(10)
    end
    @items_to_reorder = Item.need_reorder.alphabetical.to_a
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def view_cart
    if !logged_in? || current_user.nil? || current_user.role?(:shipper) || current_user.role?(:manager)
      flash[:error] = "You are not authorized to take this action. Please log in as an appropriate user."
      redirect_to home_path
    end
    @cart_items = []
    session[:cart].each do |item_id, quantity|
      oi = OrderItem.new(item_id: item_id, quantity: quantity)
      @cart_items << oi
    end
  end

  def toggle
    @oi = OrderItem.find(params[:id])
    if @oi.shipped_on.nil?
      @oi.shipped
      flash[:notice] = "Marked #{@oi.quantity} #{@oi.item.name.pluralize(@oi.quantity)} as shipped."
    end
    @oi.save!
    @not_shipped_orders = Order.not_shipped.chronological
  end

end