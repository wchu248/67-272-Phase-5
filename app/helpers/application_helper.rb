module ApplicationHelper

  include ChessStoreHelpers::Cart
  include ChessStoreHelpers::Shipping

  def cart_cost
      calculate_cart_items_cost
  end

  def shipping_cost
      calculate_cart_shipping
  end

end
