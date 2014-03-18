require 'test_helper'
require 'pry'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:product_one)
    @admin = Admin.create(email: "jack@this.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
# binding.pry
    assert_select '.items td.description dt', Product.last.name
    assert_select '.items tr', Product.all.count
    assert_select '.price', /\$[,\d]+\.\d\d/
  end
end

