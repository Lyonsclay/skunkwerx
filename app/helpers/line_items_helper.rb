module LineItemsHelper

  def current_cart
    Cart.find(session[:cart_id]) if session[:cart_id]
  end

  # This method determines path of previous page for redirection.
  # Used in cart and order actions, and therefore will evaluate to
  # products/index or malone_tunings/index.
  def shopping
    if current_cart
      unless current_cart.line_items.empty?
        if current_cart.line_items.order(:created_at).last.product
          "/products/index"
        elsif current_cart.line_items.order(:created_at).last.malone_tuning
          "/malone_tunings/index_deploy"
        end
      end
    else
      "/"
    end
  end
end
