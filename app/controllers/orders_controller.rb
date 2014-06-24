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
    @order = Order.new(order_params)
    @order << @cart.line_items
    redirect_to request.referer
  end

  private

    def order_params
      if params[:order]
        params.require(:order).permit(:name, :address, :email, :payment_type)
      end
    end
end
