class HomeController < ApplicationController
  def home
    if logged_in? && (current_user.role?(:shipper) || current_user.role?(:admin))
      @not_shipped_orders = Order.not_shipped.chronological
      @all_orders = Order.all.chronological
    end
    @items_to_reorder = Item.need_reorder.alphabetical.to_a
  end

  def about
  end

  def contact
  end

  def privacy
  end

  def cart
    if current_user.nil? or current_user.role?(:shipper) or current_user.role?(:manager)
      flash[:error] = "You are not authorized to take this action"
      redirect_to home_path
    end
  end

  def toggle
    @oi = OrderItem.find(params[:id])
    if @oi.shipped_on.nil?
      @oi.shipped_on = Date.current
      flash[:notice] = "Marked #{@oi.quantity} #{@oi.item.name.pluralize(@oi.quantity)} as shipped."
    end
    @oi.save!
    @not_shipped_orders = Order.not_shipped.chronological
  end

end