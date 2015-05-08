class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:update, :destroy]

  def index
    @line_items = LineItem.all
  end

  def show
    @line_item = LineItem.find(params[:id])
  end

  def new
    @line_item = LineItem.new
  end

  def edit
    @line_item = LineItem.find(params[:id])
  end

  def create
    product = Product.find_by item_id: params[:item_id]
    product ||= MaloneTune.find_by item_id: params[:item_id]
    @line_item = @cart.add_product(product.item_id)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item.cart }
        format.js { @current_item = @line_item }
        format.json { render action: 'show', status: :created, location: @line_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @line_item = LineItem.find(params[:id])
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @line_item.destroy
    respond_to do |format|
      format.html { redirect_to line_items_url }
      format.json { head :no_content }
    end
  end

  def remove_multiple
    if params[:line_item_ids]
      @line_items = LineItem.find(params[:line_item_ids])
      @line_items.each do |line_item|
        line_item.destroy if line_item.quantity == 1
        LineItem.decrement_counter(:quantity, line_item.id)
      end
      respond_to do |format|
        unless current_cart.empty?
          format.html { redirect_to cart_url(@line_items.first.cart_id) }
          format.json { head :no_content }
        else
          format.html { redirect_to shopping, notice: 'Your cart is currently empty' }
          format.json { head :no_content }
        end
      end
    else
      redirect_to current_cart
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:line_item_ids])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end
end
