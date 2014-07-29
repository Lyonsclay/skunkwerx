require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
    assert_select '.items tr.border td dl dt', Product.first.name
    assert_select '.items tr.border', Product.all.count
    assert_select '.price', /\$[,\d]+\.\d\d/
  end

  test "markup needed for " do
    get :index
    assert_select 'tr.border', 2
    assert_select 'table input[type=submit]', 2
  end
end

