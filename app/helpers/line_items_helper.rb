module LineItemsHelper

  def current_cart
    Cart.find(session[:cart_id]) if session[:cart_id]
  end

  def shopping
    # This method will be built out when a LineItem can
    # be associated with a MaloneTune
    if current_cart
      unless current_cart.line_items.last.product.nil?
        "/products/index"
      else
        "/malone_tunes/index_deploy"
      end
    end
  end
end
