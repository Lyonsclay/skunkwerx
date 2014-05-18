module LineItemsHelper

  def current_cart
    Cart.find(session[:cart_id])
  end

  def shopping
    # This method will be built out when a LineItem can
    # be associated with a MaloneTune
    unless current_cart.line_items
      unless current_cart.line_items.last.product_id.nil?
        "/products/index"
      end
    else
      "/products/index"
    end
  end
end
