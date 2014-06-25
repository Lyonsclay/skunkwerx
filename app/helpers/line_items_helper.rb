module LineItemsHelper

  def current_cart
    Cart.find(session[:cart_id]) if session[:cart_id]
  end

  def shopping
    if current_cart
      unless current_cart.line_items.empty?
        if current_cart.line_items.order(:created_at).last.product
          "/products/index"
        elsif current_cart.line_items.order(:created_at).last.malone_tune
          "/malone_tunes/index_deploy"
        end
      end
    else
      "/"
    end
  end
end
