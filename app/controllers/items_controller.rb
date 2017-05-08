class ItemsController < ApplicationController

  include ChessStoreHelpers::Cart

  before_action :set_item, only: [:show, :edit, :update, :destroy, :add_to_cart, :remove_one_from_cart, :delete_from_cart]

  def index
    @boards = Item.active.for_category('boards').alphabetical.paginate(:page => params[:page]).per_page(10)
    @pieces = Item.active.for_category('pieces').alphabetical.paginate(:page => params[:page]).per_page(10)
    @clocks = Item.active.for_category('clocks').alphabetical.paginate(:page => params[:page]).per_page(10)
    @supplies = Item.active.for_category('supplies').alphabetical.paginate(:page => params[:page]).per_page(10)    
    @inactive_items = Item.inactive.alphabetical.to_a
  end

  def show
    @wholesale_price_history = @item.item_prices.wholesale.chronological.to_a
    @manufacturer_price_history = @item.item_prices.manufacturer.chronological.to_a
    @similar_items = Item.for_category(@item.category).active.alphabetical.to_a - [@item]
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to item_path(@item), notice: "Successfully created #{@item.name}."
    else
      render action: 'new'
    end
  end

  def update
    if @item.update(item_params)
      redirect_to item_path(@item), notice: "Successfully updated #{@item.name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    if !@item.is_destroyable?
      flash[:error] = "Could not remove #{@item.name}. Set as inactive."
      @item.remove_unshipped_and_convert_to_inactive
      redirect_to :back
    else
      @item.destroy
      redirect_to items_path, notice: "Successfully removed #{@item.name} from the system."
    end
  end

  def add_to_cart
    add_item_to_cart(params[:id])
    flash[:notice] = "Added 1 #{@item.name} to the cart."
    redirect_to :back
  end

  def remove_one_from_cart
    remove_one_item_from_cart(params[:id])
    flash[:notice] = "Removed 1 #{@item.name} from the cart."
    redirect_to :back
  end

  def delete_from_cart
    delete_item_from_cart(params[:id])
    flash[:notice] = "Deleted #{@item.name} from the cart."
    redirect_to :back
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :color, :category, :weight, :inventory_level, :reorder_level, :active, :photo)
  end
  
end