class HomeController < ApplicationController
  def home
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
      flash[:alert] = "You are not authorized to take this action"
      redirect_to home_path
    end
  end

end