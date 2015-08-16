require 'test_helper'

class OrdersControllerTest < ActionController::TestCase

  setup do
    @request.env['HTTP_REFERER'] = products_index_url
    @product = products(:product_one)
    @cart = Cart.create
    session[:cart_id] = @cart.id
    @cart.line_items << LineItem.create(item_id: @product.item_id)
  end

  test "requires item in cart" do
    @cart.line_items.delete_all
    get :new
    assert_redirected_to request.referer
    assert_equal flash[:notice], 'Your cart is empty'
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create order" do
    assert_difference('Order.count') do
      post :create, order: orders(:order).attributes.slice("name", "address", "email")
    end
  end
end
