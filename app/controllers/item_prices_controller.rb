class ItemPricesController < ApplicationController
  def index
    @active_items = Item.active.alphabetical.paginate(page: params[:page]).per_page(10)
  end

  def new
    @item_price = ItemPrice.new
  end

  def create
    @item_price = ItemPrice.new(item_price_params)
    @item_price.start_date = Date.current
    if @item_price.save
      respond_to do |format|
        @item = @item_price.item
        format.html { redirect_to @item, notice: "Changed the price of #{@item.name}." }
        @price_history = @item_price.item.item_prices.chronological.to_a
        @similar_items = Item.for_category(@item_price.item.category).active.alphabetical.to_a - [@item]
        format.js
      end
    else
      render action: 'new'
    end
  end

  private
  def item_price_params
    params.require(:item_price).permit(:item_id, :price, :category)
  end
  
end