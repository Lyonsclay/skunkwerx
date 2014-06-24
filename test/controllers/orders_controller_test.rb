require 'test_helper'

class OrdersControllerTest < ActionController::TestCase

  setup do
    @request.env['HTTP_REFERER'] = products_index_url
    product = products(:product_one)
    @cart = Cart.create
    session[:cart_id] = @cart.id
    # @cart.line_items << LineItem.create(item_id: product.item_id)
  end

  test "requires item in cart" do
    get :new
    assert_redirected_to request.referer
    assert_equal flash[:notice], 'Your cart is empty'
  end

  test "should get new" do
    item = LineItem.new
    item.build_cart
    item.product = products(:product_one)
    item.save!
    session[:cart_id] = item.cart.id
    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, order: orders(:order).attributes.slice("name", "address", "email")
    end
  end
end