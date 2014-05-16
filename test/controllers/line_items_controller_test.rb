require 'test_helper'

class LineItemsControllerTest < ActionController::TestCase
  test "should create line_item" do
    assert_difference('LineItem.count') do
      post :create, product_id: products(:product_one).id
    end
    assert_redirected_to cart_path(assigns(:line_item).cart)
  end
end