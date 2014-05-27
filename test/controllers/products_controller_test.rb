require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
    assert_select '.items td.description dt', Product.last.name
    assert_select '.items tr', Product.all.count
    assert_select '.price', /\$[,\d]+\.\d\d/
  end

  test "markup needed for " do
    get :index
    assert_select 'td.description', 2
    assert_select 'td.description dl dd input[type=submit]', 2
  end
end

