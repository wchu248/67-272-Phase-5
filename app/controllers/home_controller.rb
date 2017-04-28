class HomeController < ApplicationController
  def home
    if logged_in? && (current_user.role?(:shipper) || current_user.role?(:admin))
      @not_shipped_orders = Order.not_shipped.chronological.paginate(:page => params[:page]).per_page(10)
      @all_orders = Order.all.chronological.paginate(:page => params[:page]).per_page(10)
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

end