class PurchasesController < ApplicationController
  
  load_and_authorize_resource

  def index
    @purchases = Purchase.all.chronological.paginate(page: params[:page]).per_page(10)
  end

  def new
    @purchase = Purchase.new
  end

  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.date = Date.current
    if @purchase.save
      respond_to do |format|
        format.html {
          redirect_to purchases_path, notice: "Successfully added a purchase for #{@purchase.quantity} #{@purchase.item.name}."
        }
        @item = @purchase.item
        format.js
      end
    else
      render action: 'new'
    end
  end

  private
  def purchase_params
    params.require(:purchase).permit(:item_id, :quantity)
  end
  
end