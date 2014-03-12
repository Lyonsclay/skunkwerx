require 'test_helper'
class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:product_one)
    @update = {
      name: 'Lorem Ipsum',
      description: 'Wibbles are fun!',
      image_url: 'lorem.jpg',
      price: 19.95,
      quantity: 20
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end

end