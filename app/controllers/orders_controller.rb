class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:new, :create]

  def new
    cart = Cart.find_by id: session[:cart_id]
    if cart.line_items.empty?
      flash[:notice] = "Your cart is empty"
      redirect_to request.referer
    end
    @order = Order.new
  end

  def create
    @order = Order.create(order_params)
    @order.line_items << @cart.line_items
    respond_to do |format|
      if @order.save
        # Must obtain destination path from shopping before
        # destroy cart. After destroy cart line_items are still
        # associated with an order, but line_item.order_id is nil.
        previous_path = shopping
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        format.html { redirect_to previous_path, notice: 'Thank you for your order.' }
        format.json { render action: 'show', status: :created, location: @order }
      else
        format.html { render action: 'new' }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Strong params
    def order_params
      if params[:order]
        params.require(:order).permit(:name, :address, :email, :payment_type)
      end
    end
end
